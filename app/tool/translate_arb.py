"""Translate lib/l10n/app_en.arb into every supported language with an
OpenAI-compatible LLM server, writing lib/l10n/app_<locale>.arb.

  python tool/translate_arb.py --api http://localhost:8000/v1 --model Qwen/Qwen3.8-27B [--locales ja,de]

Existing translations are kept. A translation is accepted only if it keeps
the source's placeholders and, for ICU plurals, the plural structure.
"""

import argparse
import json
import re
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

from openai import OpenAI

L10N = Path(__file__).parents[1] / "lib/l10n"

# ARB locale suffix -> language name for the prompt.
LOCALES = {
    "zh": "Simplified Chinese", "zh_Hant": "Traditional Chinese", "ja": "Japanese", "ko": "Korean",
    "de": "German", "fr": "French", "es": "Spanish", "pt": "Brazilian Portuguese", "pt_PT": "European Portuguese",
    "it": "Italian", "nl": "Dutch", "pl": "Polish", "sv": "Swedish", "nb": "Norwegian Bokmål", "da": "Danish",
    "fi": "Finnish", "cs": "Czech", "hu": "Hungarian", "ro": "Romanian", "hr": "Croatian", "tr": "Turkish",
    "vi": "Vietnamese", "id": "Indonesian", "ms": "Malay", "ru": "Russian", "uk": "Ukrainian", "el": "Greek",
    "ar": "Arabic", "fa": "Persian", "ur": "Urdu", "he": "Hebrew", "hi": "Hindi", "ne": "Nepali", "bn": "Bengali",
    "ta": "Tamil", "th": "Thai", "hy": "Armenian", "ka": "Georgian",
}

PROMPT = """Translate the user interface strings of "MosaicIt", an app that finds and redacts private information (names, phone numbers, ID numbers, faces) in screenshots and videos, into {language}.

Answer with one JSON object mapping every key below, unchanged, to its translation.
- Keep every {{placeholder}} exactly as written, untranslated.
- Strings in ICU plural syntax ({{count, plural, =1{{...}} other{{...}}}}) keep that syntax and its keywords; translate only the text inside the braces, and add the plural categories {language} needs (zero, one, two, few, many, other).
- Inside plural cases write the number as {{count}} (or the plural's variable), never as #.
- The note after each string says where it appears; choose the word a native app would use there (for example "redact" means hiding private information, "annotate" means labelling images by hand).
- Keep "MosaicIt" (in Chinese the app is called 码住, 碼住 in Traditional Chinese), ".onnx", ".onnx.json", "coco.json" and the "…" ellipsis.
- Use the terms the platform uses in {language} (iOS and Android menus).
- Answer with the JSON object only.

Strings (key: [text, note]):
{strings}"""

PLACEHOLDER = re.compile(r"\{(\w+)\}")


PLURAL = re.compile(r"^\{(\w+), plural,")


def ok(src: str, dst: str) -> bool:
    """Same placeholders (a plural keeps its variable and an `other` case)
    and balanced braces."""
    if dst.count("{") != dst.count("}"):
        return False
    # Flutter's ICU parser has no `#` shorthand; it would show as a literal #.
    if "#" in dst and "#" not in src:
        return False
    s_ph, d_ph = set(PLACEHOLDER.findall(src)), set(PLACEHOLDER.findall(dst))
    if m := PLURAL.match(src):
        d = PLURAL.match(dst)
        return d is not None and d.group(1) == m.group(1) and "other{" in dst.replace(" ", "") and s_ph - {m.group(1)} <= d_ph
    return s_ph == d_ph


def translate(client, model, locale, src):
    path = L10N / f"app_{locale}.arb"
    have = json.loads(path.read_text()) if path.exists() else {}
    have = {k: v for k, v in have.items() if not k.startswith("@")}
    keys = [k for k in src if not k.startswith("@")]
    for _ in range(3):
        todo = [k for k in keys if k not in have]
        if not todo:
            break
        strings = {k: [src[k], src.get(f"@{k}", {}).get("description", "")] for k in todo}
        r = client.chat.completions.create(
            model=model,
            messages=[{"role": "user", "content": PROMPT.format(language=LOCALES[locale], strings=json.dumps(strings, ensure_ascii=False, indent=1))}],
            temperature=0,
            max_tokens=16384,
            extra_body={"chat_template_kwargs": {"enable_thinking": False}},
        )
        m = re.search(r"\{.*\}", r.choices[0].message.content or "", re.S)
        try:
            got = json.loads(m.group(0)) if m else {}
        except json.JSONDecodeError:
            got = {}
        have.update({k: v for k, v in got.items() if k in todo and isinstance(v, str) and ok(src[k], v)})
    out = {"@@locale": locale, **{k: have[k] for k in keys if k in have}}
    path.write_text(json.dumps(out, ensure_ascii=False, indent=2) + "\n")
    return locale, [k for k in keys if k not in have]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--api", required=True)
    ap.add_argument("--model", required=True)
    ap.add_argument("--locales", default=",".join(LOCALES))
    args = ap.parse_args()
    client = OpenAI(base_url=args.api, api_key="none", timeout=1800)
    src = json.loads((L10N / "app_en.arb").read_text())
    locales = args.locales.split(",")
    with ThreadPoolExecutor(len(locales)) as pool:
        for locale, missing in pool.map(lambda l: translate(client, args.model, l, src), locales):
            print(f"{locale}: {len(missing)} missing {missing[:5]}", flush=True)


if __name__ == "__main__":
    main()
