# /// script
# requires-python = "==3.12.*"
# dependencies = [
#   "onnx2tf", "tensorflow", "tf-keras", "onnx", "onnx-graphsurgeon",
#   "sng4onnx", "onnxsim", "onnxruntime", "ai-edge-litert", "psutil",
# ]
# ///
"""Converts the YuNet ONNX export to the bundled `.tflite`.

    uv run to_tflite.py

The input stays NCHW with dynamic height and width (`-kat input`). Each 2x
nearest upsample (ONNX Resize) becomes Concat x4 + DepthToSpace, the same
values: onnx2tf would size the Resize from a SHAPE op, which leaves the
s8/s16 outputs without a shape until LiteRT runs the model.
"""

import tempfile
from pathlib import Path

import numpy as np
import onnx
import onnx2tf
import onnxruntime as ort
from onnx import helper, numpy_helper

HERE = Path(__file__).parent
SRC = HERE / "face_detection_yunet_2026may.onnx"


def without_resize(model: onnx.ModelProto) -> onnx.ModelProto:
    g = model.graph
    consts = {t.name: numpy_helper.to_array(t) for t in g.initializer}
    nodes = []
    for n in g.node:
        if n.op_type != "Resize":
            nodes.append(n)
            continue
        attrs = {a.name: helper.get_attribute_value(a) for a in n.attribute}
        assert attrs["mode"] == b"nearest" and attrs["nearest_mode"] == b"floor", attrs
        assert attrs["coordinate_transformation_mode"] == b"asymmetric", attrs
        assert list(consts[n.input[2]]) == [1, 1, 2, 2], n.name
        x, y = n.input[0], n.output[0]
        nodes += [
            helper.make_node("Concat", [x] * 4, [f"{y}_x4"], axis=1),
            helper.make_node("DepthToSpace", [f"{y}_x4"], [y], blocksize=2, mode="DCR"),
        ]
    del g.node[:]
    g.node.extend(nodes)
    onnx.checker.check_model(model)
    return model


def main() -> None:
    src = onnx.load(SRC)
    with tempfile.TemporaryDirectory() as tmp:
        patched = Path(tmp) / "yunet.onnx"
        onnx.save(without_resize(onnx.load(SRC)), patched)
        x = np.random.default_rng(0).uniform(0, 255, (1, 3, 640, 288)).astype(np.float32)
        want = ort.InferenceSession(src.SerializeToString()).run(None, {"input": x})
        got = ort.InferenceSession(str(patched)).run(None, {"input": x})
        for w, o in zip(want, got, strict=True):
            np.testing.assert_array_equal(w, o)
        out = Path(tmp) / "out"
        onnx2tf.convert(
            input_onnx_file_path=str(patched),
            output_folder_path=str(out),
            keep_ncw_or_nchw_or_ncdhw_input_names=["input"],
            output_signaturedefs=True,
            verbosity="error",
        )
        (out / "yunet_float32.tflite").replace(SRC.with_suffix(".tflite"))


if __name__ == "__main__":
    main()
