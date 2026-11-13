# Contributing

## Contributor License Agreement

Every contributor signs the [CLA](CLA.md) once
([中文译本](CLA_zh.md)). An automated check posts the instructions on your first
pull request, and you sign by leaving one comment:

```
I have read the CLA Document and I hereby sign the CLA
```

MosaicIt is AGPLv3 and is also intended for distribution through the App Store,
whose terms cannot all be satisfied alongside every AGPLv3 condition. The
agreement grants the maintainer the right to ship your work in those builds.
You keep the copyright to what you wrote, and you can reuse it anywhere else
however you like. Read [CLA.md](CLA.md) for the terms that actually bind — the
paragraph above is a summary and nothing more.

Two things that trip the check up:

- **Commits authored by an email address not attached to your GitHub account.**
  The check then cannot tell who wrote them. Add the address at
  <https://github.com/settings/emails> (it can stay private) and comment
  `recheck`.
- **Co-authored commits.** Everyone who authored a commit in the pull request
  signs, not only whoever opened it.

## Dependencies

Shipped code and model weights may only depend on permissively licensed
components (Apache-2.0, MIT, BSD, ISC, Zlib, MPL-2.0). No GPL/AGPL code or
weights, including Ultralytics models, in anything that is distributed.

## Data

Never commit real personal data. Datasets are generated from fake values, and
real screenshots used for evaluation must come from accounts filled with
invented data.
