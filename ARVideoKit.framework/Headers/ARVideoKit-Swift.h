// Generated by Apple Swift version 5.0.1 effective-4.2 (swiftlang-1001.0.82.4 clang-1001.0.46.5)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <Foundation/Foundation.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus)
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR(_extensibility) __attribute__((enum_extensibility(_extensibility)))
# else
#  define SWIFT_ENUM_ATTR(_extensibility)
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name, _extensibility) enum _name : _type _name; enum SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) SWIFT_ENUM(_type, _name, _extensibility)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if __has_feature(modules)
#if __has_warning("-Watimport-in-framework-header")
#pragma clang diagnostic ignored "-Watimport-in-framework-header"
#endif
@import CoreMedia;
@import CoreVideo;
@import Foundation;
@import ObjectiveC;
@import Photos;
@import UIKit;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"

#if __has_attribute(external_source_symbol)
# pragma push_macro("any")
# undef any
# pragma clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in="ARVideoKit",generated_declaration))), apply_to=any(function,enum,objc_interface,objc_category,objc_protocol))
# pragma pop_macro("any")
#endif

/// Allows specifying the final video orientation.
typedef SWIFT_ENUM(NSInteger, ARFrameMode, closed) {
  ARFrameModeAuto = 0,
  ARFrameModeAspectFit = 1,
/// Recommended for iPhone X
  ARFrameModeAspectFill = 2,
};

/// Allows specifying the accepted orientaions in a <code>UIViewController</code> with AR scenes.
typedef SWIFT_ENUM(NSInteger, ARInputViewOrientation, closed) {
/// Enables the portrait input views orientation.
  ARInputViewOrientationPortrait = 1,
/// Enables the landscape left input views orientation.
  ARInputViewOrientationLandscapeLeft = 3,
/// Enables the landscape right input views orientation.
  ARInputViewOrientationLandscapeRight = 4,
};

/// Allows specifying the video rendering frame per second <code>FPS</code> rate.
typedef SWIFT_ENUM(NSInteger, ARVideoFrameRate, closed) {
/// The framework automatically sets the most appropriate <code>FPS</code> based on the device support.
  ARVideoFrameRateAuto = 0,
/// Sets the <code>FPS</code> to 30 frames per second.
  ARVideoFrameRateFps30 = 30,
/// Sets the <code>FPS</code> to 60 frames per second.
  ARVideoFrameRateFps60 = 60,
};

/// Allows specifying the final video orientation.
typedef SWIFT_ENUM(NSInteger, ARVideoOrientation, closed) {
/// The framework automatically sets the video orientation based on the active <code>ARInputViewOrientation</code> orientations.
  ARVideoOrientationAuto = 0,
/// Sets the video orientation to always portrait.
  ARVideoOrientationAlwaysPortrait = 1,
/// Sets the video orientation to always landscape.
  ARVideoOrientationAlwaysLandscape = 2,
};


/// A class that configures the Augmented Reality View orientations.
/// author:
/// Ahmed Fathi Bekhit
/// <ul>
///   <li>
///     <a href="http://github.com/AFathi">Github</a>
///   </li>
///   <li>
///     <a href="http://ahmedbekhit.com">Website</a>
///   </li>
///   <li>
///     <a href="http://twitter.com/iAFapps">Twitter</a>
///   </li>
///   <li>
///     <a href="mailto:me@ahmedbekhit.com">Email</a>
///   </li>
/// </ul>
SWIFT_CLASS("_TtC10ARVideoKit6ARView") SWIFT_AVAILABILITY(ios,introduced=11.0)
@interface ARView : NSObject
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_DEPRECATED_MSG("-init is unavailable");
@end

@class NSCoder;

/// A <code>PHLivePhotoPlus</code> object is a <code>PHLivePhoto</code> sub-class that contains objects to allow manual exporting of a live photo.
/// author:
/// Ahmed Fathi Bekhit
/// <ul>
///   <li>
///     <a href="http://github.com/AFathi">Github</a>
///   </li>
///   <li>
///     <a href="http://ahmedbekhit.com">Website</a>
///   </li>
///   <li>
///     <a href="http://twitter.com/iAFapps">Twitter</a>
///   </li>
///   <li>
///     <a href="mailto:me@ahmedbekhit.com">Email</a>
///   </li>
/// </ul>
SWIFT_CLASS("_TtC10ARVideoKit15PHLivePhotoPlus") SWIFT_AVAILABILITY(ios,introduced=9.1)
@interface PHLivePhotoPlus : PHLivePhoto
/// A <code>PHLivePhoto</code> object that returns the Live Photo content from <code>PHLivePhotoPlus</code>.
@property (nonatomic, strong) PHLivePhoto * _Nullable livePhoto;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithPhoto:(PHLivePhoto * _Nonnull)photo OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@protocol RecordARDelegate;
@protocol RenderARDelegate;
enum RecordARStatus : NSInteger;
enum RecordARMicrophoneStatus : NSInteger;
enum RecordARMicrophonePermission : NSInteger;
@class ARSCNView;
@class ARSKView;
@class SCNView;
@class UIImage;

/// This class renders the <code>ARSCNView</code> or <code>ARSKView</code> content with the device’s camera stream to generate a video 📹, photo 🌄, live photo 🎇 or GIF 🎆.
/// author:
/// 🤓 Ahmed Fathi Bekhit © 2017
/// <ul>
///   <li>
///     <a href="http://github.com/AFathi">Github</a>
///   </li>
///   <li>
///     <a href="http://ahmedbekhit.com">Website</a>
///   </li>
///   <li>
///     <a href="http://twitter.com/iAFapps">Twitter</a>
///   </li>
///   <li>
///     <a href="mailto:me@ahmedbekhit.com">Email</a>
///   </li>
/// </ul>
SWIFT_CLASS("_TtC10ARVideoKit8RecordAR") SWIFT_AVAILABILITY(ios,introduced=11.0)
@interface RecordAR : ARView
/// An object that passes the AR recorder errors and status in the protocol methods.
@property (nonatomic, strong) id <RecordARDelegate> _Nullable delegate;
/// An object that passes the AR rendered content in the protocol method.
@property (nonatomic, strong) id <RenderARDelegate> _Nullable renderAR;
/// An object that returns the AR recorder current status.
@property (nonatomic, readonly) enum RecordARStatus status;
/// An object that returns the current Microphone status.
@property (nonatomic, readonly) enum RecordARMicrophoneStatus micStatus;
/// An object that allow customizing when to ask for Microphone permission, if needed. Default is <code>.manual</code>.
@property (nonatomic) enum RecordARMicrophonePermission requestMicPermission;
/// An object that allow customizing the video frame per second rate. Default is <code>.auto</code>.
@property (nonatomic) enum ARVideoFrameRate fps;
/// An object that allow customizing the video orientation. Default is <code>.auto</code>.
@property (nonatomic) enum ARVideoOrientation videoOrientation;
/// An object that allow customizing the AR content mode. Default is <code>.auto</code>.
@property (nonatomic) enum ARFrameMode contentMode;
/// A boolean that enables or disables AR content rendering before recording for image & video processing. Default is <code>true</code>.
@property (nonatomic) BOOL onlyRenderWhileRecording;
/// A boolean that enables or disables audio recording. Default is <code>true</code>.
@property (nonatomic) BOOL enableAudio;
/// A boolean that enables or disables audio <code>mixWithOthers</code> if audio recording is enabled. This allows playing music and recording audio at the same time. Default is <code>true</code>.
@property (nonatomic) BOOL enableMixWithOthers;
/// A boolean that enables or disables adjusting captured media for sharing online. Default is <code>true</code>.
@property (nonatomic) BOOL adjustVideoForSharing;
/// A boolean that enables or disables adjusting captured GIFs for sharing online. Default is <code>true</code>.
@property (nonatomic) BOOL adjustGIFForSharing;
/// A boolean that enables or disables clearing cached media after exporting to Camera Roll. Default is <code>true</code>.
@property (nonatomic) BOOL deleteCacheWhenExported;
/// A boolean that enables or disables using envronment light rendering. Default is <code>false</code>.
@property (nonatomic) BOOL enableAdjustEnvironmentLighting;
/// Initialize 🌞🍳 <code>RecordAR</code> with an <code>ARSCNView</code> 🚀.
- (nullable instancetype)initWithARSceneKit:(ARSCNView * _Nonnull)ARSceneKit OBJC_DESIGNATED_INITIALIZER;
/// Initialize 🌞🍳 <code>RecordAR</code> with an <code>ARSKView</code> 👾.
- (nullable instancetype)initWithARSpriteKit:(ARSKView * _Nonnull)ARSpriteKit OBJC_DESIGNATED_INITIALIZER;
/// Initialize 🌞🍳 <code>RecordAR</code> with an <code>SCNView</code> 🚀.
- (nullable instancetype)initWithSceneKit:(SCNView * _Nonnull)SceneKit OBJC_DESIGNATED_INITIALIZER;
/// A method that renders a photo 🌄 and returns it as <code>UIImage</code>.
- (UIImage * _Nonnull)photo SWIFT_WARN_UNUSED_RESULT;
/// A method that renders a <code>PHLivePhoto</code> 🎇 and returns <code>PHLivePhotoPlus</code> in the completion handler.
/// In order to manually export the <code>PHLivePhotoPlus</code>, use <code>export(live photo: PHLivePhotoPlus)</code> method.
/// \param export A boolean that enables or disables automatically exporting the <code>PHLivePhotoPlus</code> when ready.
///
/// \param finished A block that will be called when Live Photo rendering is complete.
/// The block returns the following parameters:
/// <code>status</code>
/// A boolean that returns <code>true</code> when a <code>PHLivePhotoPlus</code> is successfully rendered. Otherwise, it returns <code>false</code>.
/// <code>livePhoto</code>
/// A <code>PHLivePhotoPlus</code> object that contains a <code>PHLivePhoto</code> and other objects to allow manual exporting of a live photo.
/// <code>permissionStatus</code>
/// A <code>PHAuthorizationStatus</code> object that returns the current application’s status for exporting media to the Photo Library. It returns <code>nil</code> if the <code>export</code> parameter is <code>false</code>.
/// <code>exported</code>
/// A boolean that returns <code>true</code> when a <code>PHLivePhotoPlus</code> is successfully exported to the Photo Library. Otherwise, it returns <code>false</code>.
///
- (void)livePhotoWithExport:(BOOL)export_ :(void (^ _Nullable)(BOOL, PHLivePhotoPlus * _Nonnull, PHAuthorizationStatus, BOOL))finished;
/// A method that generates a GIF 🎆 image and returns its local path (<code>URL</code>) in the completion handler.
/// In order to manually export the GIF image <code>URL</code>, use <code>func export(image path: URL)</code> method.
/// \param duration A <code>TimeInterval</code> object that can be set to the duration specified in seconds.
///
/// \param export A boolean that enables or disables automatically exporting the GIF image <code>URL</code> when ready.
///
/// \param finished A block that will be called when GIF image rendering is complete.
/// The block returns the following parameters:
/// <code>status</code>
/// A boolean that returns <code>true</code> when a GIF image <code>URL</code> is successfully rendered. Otherwise, it returns <code>false</code>.
/// <code>gifPath</code>
/// A <code>URL</code> object that contains the local file path of the GIF image to allow manual exporting of a GIF.
/// <code>permissionStatus</code>
/// A <code>PHAuthorizationStatus</code> object that returns the current application’s status for exporting media to the Photo Library. It returns <code>nil</code> if the <code>export</code> parameter is <code>false</code>.
/// <code>exported</code>
/// A boolean that returns <code>true</code> when a GIF image <code>URL</code> is successfully exported to the Photo Library. Otherwise, it returns <code>false</code>.
///
- (void)gifForDuration:(NSTimeInterval)duration export:(BOOL)export_ :(void (^ _Nullable)(BOOL, NSURL * _Nonnull, PHAuthorizationStatus, BOOL))finished;
/// A method that starts or resumes ⏯ recording a video 📹.
- (void)record;
/// A method that starts recording a video 📹 with a specified duration ⏳ in seconds.
/// In order to stop the recording before the specified duration, simply call <code>stop()</code> or <code>stopAndExport()</code> methods.
/// warning:
/// You CAN NOT <code>pause()</code> video recording when a duration is specified.
/// \param duration A <code>TimeInterval</code> object that can be set to the duration specified in seconds.
///
/// \param finished A block that will be called when the specified <code>duration</code> has ended.
/// The block returns the following parameter:
/// <code>videoPath</code>
/// A <code>URL</code> object that contains the local file path of the video to allow manual exporting or preview of the video.
///
- (void)recordForDuration:(NSTimeInterval)duration :(void (^ _Nullable)(NSURL * _Nonnull))finished;
/// A method that pauses recording a video ⏸📹.
/// In order to resume recording, simply call the <code>record()</code> method.
- (void)pause;
/// A method that stops ⏹ recording a video 📹 and exports it to the Photo Library 📲💾.
/// \param finished A block that will be called when the export process is complete.
/// The block returns the following parameters:
/// <code>videoPath</code>
/// A <code>URL</code> object that contains the local file path of the video to allow manual exporting or preview of the video.
/// <code>permissionStatus</code>
/// A <code>PHAuthorizationStatus</code> object that returns the current application’s status for exporting media to the Photo Library.
/// <code>exported</code>
/// A boolean that returns <code>true</code> when a video is successfully exported to the Photo Library. Otherwise, it returns <code>false</code>.
///
- (void)stopAndExport:(void (^ _Nullable)(NSURL * _Nonnull, PHAuthorizationStatus, BOOL))finished;
/// A method that stops ⏹ recording a video 📹 and returns the video path in the completion handler.
/// \param finished A block that will be called when the specified <code>duration</code> has ended.
/// The block returns the following parameter:
/// <code>videoPath</code>
/// A <code>URL</code> object that contains the local file path of the video to allow manual exporting or preview of the video.
///
- (void)stop:(void (^ _Nullable)(NSURL * _Nonnull))finished;
/// A method that exports a video 📹 file path to the Photo Library 📲💾.
/// \param path A <code>URL</code> object that can be set to a local video file path to export to the Photo Library.
///
/// \param finished A block that will be called when the export process is complete.
/// The block returns the following parameters:
/// <code>exported</code>
/// A boolean that returns <code>true</code> when a video is successfully exported to the Photo Library. Otherwise, it returns <code>false</code>.
/// <code>permissionStatus</code>
/// A <code>PHAuthorizationStatus</code> object that returns the current application’s status for exporting media to the Photo Library.
///
- (void)exportWithVideo:(NSURL * _Nonnull)path :(void (^ _Nullable)(BOOL, PHAuthorizationStatus))finished;
/// A method that exports any image 🌄/🎆 (including gif, jpeg, and png) to the Photo Library 📲💾.
/// \param path A <code>URL</code> object that can be set to a local image file path to export to the Photo Library.
///
/// \param UIImage A <code>UIImage</code> object.
///
/// \param finished A block that will be called when the export process is complete.
/// The block returns the following parameters:
/// <code>exported</code>
/// A boolean that returns <code>true</code> when an image is successfully exported to the Photo Library. Otherwise, it returns <code>false</code>.
/// <code>permissionStatus</code>
/// A <code>PHAuthorizationStatus</code> object that returns the current application’s status for exporting media to the Photo Library.
///
- (void)exportWithImage:(NSURL * _Nullable)path UIImage:(UIImage * _Nullable)UIImage :(void (^ _Nullable)(BOOL, PHAuthorizationStatus))finished;
/// A method that exports a <code>PHLivePhotoPlus</code> 🎇 object to the Photo Library 📲💾.
/// The block returns the following parameters:
/// <code>exported</code>
/// A boolean that returns <code>true</code> when the Live Photo is successfully exported to the Photo Library. Otherwise, it returns <code>false</code>.
/// <code>permissionStatus</code>
/// A <code>PHAuthorizationStatus</code> object that returns the current application’s status for exporting media to the Photo Library.
/// \param photo A <code>PHLivePhotoPlus</code> object that can be set to the returned <code>PHLivePhotoPlus</code> object in the <code>livePhoto(export: Bool, _ finished:{})</code> method.
///
/// \param finished A block that will be called when the export process is complete.
///
- (void)exportWithLive:(PHLivePhotoPlus * _Nonnull)photo :(void (^ _Nullable)(BOOL, PHAuthorizationStatus))finished;
/// A method that requsts microphone 🎙 permission manually, if micPermission is set to <code>manual</code>.
/// The block returns the following parameter:
/// <code>status</code>
/// A boolean that returns <code>true</code> when a the Microphone access is permitted. Otherwise, it returns <code>false</code>.
/// \param finished A block that will be called when the audio permission is requested.
///
- (void)requestMicrophonePermission:(void (^ _Nullable)(BOOL))finished;
@end



@class ARConfiguration;

SWIFT_AVAILABILITY(ios,introduced=11.0)
@interface RecordAR (SWIFT_EXTENSION(ARVideoKit))
/// A method that prepares the video recorder with <code>ARConfiguration</code> 📝.
/// Recommended to use in the <code>UIViewController</code>’s method <code>func viewWillAppear(_ animated: Bool)</code>
/// \param configuration An object that defines motion and scene tracking behaviors for the session.
///
- (void)prepare:(ARConfiguration * _Nullable)configuration;
/// A method that switches off the orientation lock used in a <code>UIViewController</code> with AR scenes 📐😴.
/// Recommended to use in the <code>UIViewController</code>’s method <code>func viewWillDisappear(_ animated: Bool)</code>.
- (void)rest;
@end




/// The recorder protocol.
/// author:
/// Ahmed Fathi Bekhit
/// <ul>
///   <li>
///     <a href="http://github.com/AFathi">Github</a>
///   </li>
///   <li>
///     <a href="http://ahmedbekhit.com">Website</a>
///   </li>
///   <li>
///     <a href="http://twitter.com/iAFapps">Twitter</a>
///   </li>
///   <li>
///     <a href="mailto:me@ahmedbekhit.com">Email</a>
///   </li>
/// </ul>
SWIFT_PROTOCOL("_TtP10ARVideoKit16RecordARDelegate_") SWIFT_AVAILABILITY(ios,introduced=11.0)
@protocol RecordARDelegate
/// A protocol method that is triggered when a recorder ends recording.
/// \param path A <code>URL</code> object that returns the video file path.
///
/// \param noError A boolean that returns true when the recorder ends without errors. Otherwise, it returns false.
///
- (void)recorderWithDidEndRecording:(NSURL * _Nonnull)path with:(BOOL)noError;
/// A protocol method that is triggered when a recorder fails recording.
/// \param error An <code>Error</code> object that returns the error value.
///
/// \param status A string that returns the reason of the recorder failure in a string literal format.
///
- (void)recorderWithDidFailRecording:(NSError * _Nullable)error and:(NSString * _Nonnull)status;
@optional
/// A protocol method that is triggered when a recorder is modified.
/// \param duration A double that returns the duration of current recording
///
- (void)recorderWithDidUpdateRecording:(NSTimeInterval)duration;
@required
/// A protocol method that is triggered when the application will resign active.
/// note:
/// Check <a href="https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1622950-applicationwillresignactive">applicationWillResignActive(_:)</a> for more information.
/// \param status A <code>RecordARStatus</code> object that returns the AR recorder current status.
///
- (void)recorderWithWillEnterBackground:(enum RecordARStatus)status;
@end

/// Allows specifying when to request Microphone access.
typedef SWIFT_ENUM(NSInteger, RecordARMicrophonePermission, closed) {
/// The framework automatically requests Microphone access when needed.
  RecordARMicrophonePermissionAuto = 0,
/// Allows manual permission request.
  RecordARMicrophonePermissionManual = 1,
};

/// An object that returns the current Microphone status.
typedef SWIFT_ENUM(NSInteger, RecordARMicrophoneStatus, closed) {
  RecordARMicrophoneStatusUnknown = 0,
  RecordARMicrophoneStatusEnabled = 1,
  RecordARMicrophoneStatusDisabled = 2,
};

/// An object that returns the AR recorder current status.
typedef SWIFT_ENUM(NSInteger, RecordARStatus, closed) {
/// The current status of the recorder is unknown.
  RecordARStatusUnknown = 0,
/// The current recorder is ready to record.
  RecordARStatusReadyToRecord = 1,
/// The current recorder is recording.
  RecordARStatusRecording = 2,
/// The current recorder is paused.
  RecordARStatusPaused = 3,
};


/// The renderer protocol.
/// author:
/// Ahmed Fathi Bekhit
/// <ul>
///   <li>
///     <a href="http://github.com/AFathi">Github</a>
///   </li>
///   <li>
///     <a href="http://ahmedbekhit.com">Website</a>
///   </li>
///   <li>
///     <a href="http://twitter.com/iAFapps">Twitter</a>
///   </li>
///   <li>
///     <a href="mailto:me@ahmedbekhit.com">Email</a>
///   </li>
/// </ul>
SWIFT_PROTOCOL("_TtP10ARVideoKit16RenderARDelegate_") SWIFT_AVAILABILITY(ios,introduced=11.0)
@protocol RenderARDelegate
/// A protocol method that is triggered when a frame renders the <code>ARSCNView</code> or <code>ARSKView</code> content with the device’s camera stream.
/// \param buffer A <code>CVPixelBuffer</code> object that returns the rendered buffer.
///
/// \param time A <code>CMTime</code> object that returns the time a buffer was rendered with.
///
/// \param rawBuffer A <code>CVPixelBuffer</code> object that returns the raw buffer.
///
- (void)frameWithDidRender:(CVPixelBufferRef _Nonnull)buffer with:(CMTime)time using:(CVPixelBufferRef _Nonnull)rawBuffer;
@end










/// A struct that identifies the application <code>UIViewController</code>s and their orientations.
/// author:
/// Ahmed Fathi Bekhit
/// <ul>
///   <li>
///     <a href="http://github.com/AFathi">Github</a>
///   </li>
///   <li>
///     <a href="http://ahmedbekhit.com">Website</a>
///   </li>
///   <li>
///     <a href="http://twitter.com/iAFapps">Twitter</a>
///   </li>
///   <li>
///     <a href="mailto:me@ahmedbekhit.com">Email</a>
///   </li>
/// </ul>
SWIFT_CLASS("_TtC10ARVideoKit6ViewAR") SWIFT_AVAILABILITY(ios,introduced=11.0)
@interface ViewAR : NSObject
/// A <code>UIInterfaceOrientationMask</code> object that returns the recommended orientations for a <code>UIViewController</code> with AR scenes.
/// Recommended to return in the application delegate method <code>func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask</code>.
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly) UIInterfaceOrientationMask orientation;)
+ (UIInterfaceOrientationMask)orientation SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

#if __has_attribute(external_source_symbol)
# pragma clang attribute pop
#endif
#pragma clang diagnostic pop