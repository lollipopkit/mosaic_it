//! API exposed to the Flutter app through flutter_rust_bridge.

pub mod api;
#[rustfmt::skip]
mod frb_generated;
#[cfg(target_vendor = "apple")]
mod vision;
