//! Text line positions from Apple Vision (annotation mode).

use objc2::AnyThread;
use objc2::rc::Retained;
use objc2_foundation::{NSArray, NSDictionary, NSString, NSURL};
use objc2_vision::{VNImageRequestHandler, VNRecognizeTextRequest, VNRequest, VNRequestTextRecognitionLevel};

use crate::api::PixelRect;

pub fn text_lines(path: &str, width: f32, height: f32) -> anyhow::Result<Vec<PixelRect>> {
    let url = NSURL::fileURLWithPath(&NSString::from_str(path));
    // SAFETY: an empty options dictionary is valid for every option type.
    let handler = unsafe {
        VNImageRequestHandler::initWithURL_options(VNImageRequestHandler::alloc(), &url, &NSDictionary::new())
    };
    let request = VNRecognizeTextRequest::new();
    // Accurate is the level that reads CJK; language correction would
    // only change the text, which is not used.
    request.setRecognitionLevel(VNRequestTextRecognitionLevel::Accurate);
    request.setUsesLanguageCorrection(false);
    request.setAutomaticallyDetectsLanguage(true);
    let as_request: Retained<VNRequest> = Retained::into_super(Retained::into_super(request.clone()));
    handler
        .performRequests_error(&NSArray::from_retained_slice(&[as_request]))
        .map_err(|e| anyhow::anyhow!("text recognition: {}", e.localizedDescription()))?;
    let Some(results) = request.results() else {
        return Ok(vec![]);
    };
    Ok(results
        .iter()
        .map(|o| {
            // SAFETY: a plain property read on a result of this request.
            let b = unsafe { o.boundingBox() };
            // Normalized, origin at the lower left.
            let (x, y, w, h) = (
                b.origin.x as f32,
                b.origin.y as f32,
                b.size.width as f32,
                b.size.height as f32,
            );
            PixelRect {
                left: x * width,
                top: (1.0 - y - h) * height,
                right: (x + w) * width,
                bottom: (1.0 - y) * height,
            }
        })
        .collect())
}
