// Apple Vision text lines on a synthetic two-line image (fixture rendered with
// Arial 40 px: lines at y ≈ 40 and 140 in a 600×260 image).
#![cfg(target_vendor = "apple")]

#[test]
fn finds_both_lines_in_pixels() {
    let path = concat!(env!("CARGO_MANIFEST_DIR"), "/tests/fixtures/two-lines.png");
    let mut lines = unseen_ffi::api::text_lines(path.to_string()).unwrap();
    lines.sort_by(|a, b| a.top.total_cmp(&b.top));
    assert_eq!(lines.len(), 2, "{lines:?}");
    for (l, y) in lines.iter().zip([40.0, 140.0]) {
        assert!(l.left >= 20.0 && l.left < 45.0, "{l:?}");
        assert!(l.top > y - 10.0 && l.top < y + 20.0, "{l:?}");
        assert!(l.bottom > l.top + 20.0 && l.bottom < y + 60.0, "{l:?}");
    }
}
