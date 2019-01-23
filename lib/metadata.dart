class Metadata {
  /// ExIF meta data
  final ExifMetadata exif;

  /// GPS meta data
  final GpsMetadata gps;

  /// Device meta data
  final DeviceMetadata device;

  Metadata.fromMap(Map json)
      : exif = ExifMetadata.fromMap(json),
        gps = GpsMetadata.fromMap(json),
        device = DeviceMetadata.fromMap(json);
}

class ExifMetadata {
  /// The number of columns of image data, equal to the number of pixels per row. In JPEG
  /// compressed data, this tag shall not be used because a JPEG marker is used instead of it
  final double ImageWidth;

  /// The number of rows of image data. In JPEG compressed data, this tag shall not be used
  /// because a JPEG marker is used instead of it.
  final double ImageLength;

  /// The number of bits per image component. In this standard each component of the image is
  /// 8 bits, so the value for this tag is 8. In JPEG compressed data, this tag shall not be
  /// used because a JPEG marker is used instead of it
  final int BitsPerSample;

  /// The compression scheme used for the image data. When a primary image is JPEG compressed,
  /// this designation is not necessary. So, this tag shall not be recorded. When thumbnails use
  /// JPEG compression, this tag value is set to 6.
  final int Compression;

  /// The pixel composition. In JPEG compressed data, this tag shall not be used because a JPEG
  /// marker is used instead of it.
  final int PhotometricInterpretation;

  /// The image orientation viewed in terms of rows and columns.
  final int Orientation;

  /// The number of components per pixel. Since this standard applies to RGB and YCbCr images,
  /// the value set for this tag is 3. In JPEG compressed data, this tag shall not be used because
  /// a JPEG marker is used instead of it.
  final int SamplesPerPixel;

  /// Indicates whether pixel components are recorded in chunky or planar format. In JPEG
  /// compressed data, this tag shall not be used because a JPEG marker is used instead of it.
  /// If this field does not exist, the TIFF default, {@link #FORMAT_CHUNKY}, is assumed.
  final int PlanarConfiguration;

  /// The sampling ratio of chrominance components in relation to the luminance component.
  /// In JPEG compressed data a JPEG marker is used instead of this tag. So, this tag shall not
  /// be recorded.
  final int YCbCrSubSampling;

  /// The position of chrominance components in relation to the luminance component. This field
  /// is designated only for JPEG compressed data or uncompressed YCbCr data. The TIFF default is
  /// {@link #Y_CB_CR_POSITIONING_CENTERED}; but when Y:Cb:Cr = 4:2:2 it is recommended in this
  /// standard that {@link #Y_CB_CR_POSITIONING_CO_SITED} be used to record data, in order to
  /// improve the image quality when viewed on TV systems. When this field does not exist,
  /// the reader shall assume the TIFF default. In the case of Y:Cb:Cr = 4:2:0, the TIFF default
  /// ({@link #Y_CB_CR_POSITIONING_CENTERED}) is recommended. If the Exif/DCF reader does not
  /// have the capability of supporting both kinds of positioning, it shall follow the TIFF
  /// default regardless of the value in this field. It is preferable that readers can support
  /// both centered and co-sited positioning.
  final int YCbCrPositioning;

  /// The number of pixels per {@link #TAG_RESOLUTION_UNIT} in the {@link #TAG_IMAGE_WIDTH}
  /// direction. When the image resolution is unknown, 72 [dpi] shall be designated.
  final double XResolution;

  /// The number of pixels per {@link #TAG_RESOLUTION_UNIT} in the {@link #TAG_IMAGE_WIDTH}
  /// direction. The same value as {@link #TAG_X_RESOLUTION} shall be designated.
  final double YResolution;

  /// The unit for measuring {@link #TAG_X_RESOLUTION} and {@link #TAG_Y_RESOLUTION}. The same
  /// unit is used for both {@link #TAG_X_RESOLUTION} and {@link #TAG_Y_RESOLUTION}. If the image
  /// resolution is unknown, {@link #RESOLUTION_UNIT_INCHES} shall be designated.
  final int ResolutionUnit;

  /// For each strip, the byte offset of that strip. It is recommended that this be selected
  /// so the number of strip bytes does not exceed 64 KBytes.In the case of JPEG compressed data,
  /// this designation is not necessary. So, this tag shall not be recorded.
  final double StripOffsets;

  /// The number of rows per strip. This is the number of rows in the image of one strip when
  /// an image is divided into strips. In the case of JPEG compressed data, this designation is
  /// not necessary. So, this tag shall not be recorded.
  final double RowsPerStrip;

  /// The total number of bytes in each strip. In the case of JPEG compressed data, this
  /// designation is not necessary. So, this tag shall not be recorded.
  final double StripByteCounts;

  /// The offset to the start byte (SOI) of JPEG compressed thumbnail data. This shall not be
  /// used for primary image JPEG data.
  final double JPEGInterchangeFormat;

  /// The number of bytes of JPEG compressed thumbnail data. This is not used for primary image
  /// JPEG data. JPEG thumbnails are not divided but are recorded as a continuous JPEG bitstream
  /// from SOI to EOI. APPn and COM markers should not be recorded. Compressed thumbnails shall be
  /// recorded in no more than 64 KBytes, including all other data to be recorded in APP1.
  final double JPEGInterchangeFormatLength;

  /// A transfer function for the image, described in tabular style. Normally this tag need not
  /// be used, since color space is specified in {@link #TAG_COLOR_SPACE}.
  final int TransferFunction;

  /// The chromaticity of the white point of the image. Normally this tag need not be used,
  /// since color space is specified in {@link #TAG_COLOR_SPACE}.
  final double WhitePoint;

  /// The chromaticity of the three primary colors of the image. Normally this tag need not
  /// be used, since color space is specified in {@link #TAG_COLOR_SPACE}.
  final double PrimaryChromaticities;

  /// The matrix coefficients for transformation from RGB to YCbCr image data. About
  /// the default value, please refer to JEITA CP-3451C Spec, Annex D.
  final double YCbCrCoefficients;

  /// The reference black point value and reference white point value. No defaults are given
  /// in TIFF, but the values below are given as defaults here. The color space is declared in
  /// a color space information tag, with the default being the value that gives the optimal image
  /// characteristics Interoperability these conditions
  final double ReferenceBlackWhite;

  /// The date and time of image creation. In this standard it is the date and time the file
  /// was changed. The format is "YYYY:MM:DD HH:MM:SS" with time shown in 24-hour format, and
  /// the date and time separated by one blank character ({@code 0x20}). When the date and time
  /// are unknown, all the character spaces except colons (":") should be filled with blank
  /// characters, or else the Interoperability field should be filled with blank characters.
  /// The character string length is 20 Bytes including NULL for termination. When the field is
  /// left blank, it is treated as unknown.
  final String DateTime;

  /// An ASCII string giving the title of the image. It is possible to be added a comment
  /// such as "1988 company picnic" or the like. Two-byte character codes cannot be used. When
  /// a 2-byte code is necessary, {@link #TAG_USER_COMMENT} is to be used.
  final String ImageDescription;

  /// This tag records the name of the camera owner, photographer or image creator.
  /// The detailed format is not specified, but it is recommended that the information be written
  /// as in the example below for ease of Interoperability. When the field is left blank, it is
  /// treated as unknown.
  final String Artist;

  /// Copyright information. In this standard the tag is used to indicate both the photographer
  /// and editor copyrights. It is the copyright notice of the person or organization claiming
  /// rights to the image. The Interoperability copyright statement including date and rights
  /// should be written in this field; e.g., "Copyright, John Smith, 19xx. All rights reserved."
  /// In this standard the field records both the photographer and editor copyrights, with each
  /// recorded in a separate part of the statement. When there is a clear distinction between
  /// the photographer and editor copyrights, these are to be written in the order of photographer
  /// followed by editor copyright, separated by NULL (in this case, since the statement also ends
  /// with a NULL, there are two NULL codes) (see example 1). When only the photographer copyright
  /// is given, it is terminated by one NULL code (see example 2). When only the editor copyright
  /// is given, the photographer copyright part consists of one space followed by a terminating
  /// NULL code, then the editor copyright is given (see example 3). When the field is left blank,
  /// it is treated as unknown.
  final String Copyright;

  /// The version of this standard supported. Nonexistence of this field is taken to mean
  /// nonconformance to the standard. In according with conformance to this standard, this tag
  /// shall be recorded like "0230” as 4-byte ASCII.
  final String ExifVersion;

  /// The Flashpix format version supported by a FPXR file. If the FPXR function supports
  /// Flashpix format Ver. 1.0, this is indicated similarly to {@link #TAG_EXIF_VERSION} by
  /// recording "0100" as 4-byte ASCII.
  final String FlashpixVersion;

  /// The color space information tag is always recorded as the color space specifier.
  /// Normally {@link #COLOR_SPACE_S_RGB} is used to define the color space based on the PC
  /// monitor conditions and environment. If a color space other than {@link #COLOR_SPACE_S_RGB}
  /// is used, {@link #COLOR_SPACE_UNCALIBRATED} is set. Image data recorded as
  /// {@link #COLOR_SPACE_UNCALIBRATED} may be treated as {@link #COLOR_SPACE_S_RGB} when it is
  /// converted to Flashpix
  final int ColorSpace;

  /// Indicates the value of coefficient gamma. The formula of transfer function used for image
  /// reproduction is expressed as follows.
  final double Gamma;

  /// Information specific to compressed data. When a compressed file is recorded, the valid
  /// width of the meaningful image shall be recorded in this tag, whether or not there is padding
  /// data or a restart marker. This tag shall not exist in an uncompressed file.
  final double PixelXDimension;

  /// Information specific to compressed data. When a compressed file is recorded, the valid
  /// height of the meaningful image shall be recorded in this tag, whether or not there is
  /// padding data or a restart marker. This tag shall not exist in an uncompressed file.
  /// Since data padding is unnecessary in the vertical direction, the number of lines recorded
  /// in this valid image height tag will in fact be the same as that recorded in the SOF.
  final double PixelYDimension;

  /// Information specific to compressed data. The channels of each component are arranged
  /// in order from the 1st component to the 4th. For uncompressed data the data arrangement is
  /// given in the {@link #TAG_PHOTOMETRIC_INTERPRETATION}. However, since
  /// {@link #TAG_PHOTOMETRIC_INTERPRETATION} can only express the order of Y, Cb and Cr, this tag
  /// is provided for cases when compressed data uses components other than Y, Cb, and Cr and to
  /// enable support of other sequences.
  final String ComponentsConfiguration;

  /// Information specific to compressed data. The compression mode used for a compressed image
  /// is indicated in unit bits per pixel.
  final double CompressedBitsPerPixel;

  /// A tag for Exif users to write keywords or comments on the image besides those in
  /// {@link #TAG_IMAGE_DESCRIPTION}, and without the character code limitations of it.
  final String UserComment;

  /// This tag is used to record the name of an audio file related to the image data. The only
  /// relational information recorded here is the Exif audio file name and extension (an ASCII
  /// string consisting of 8 characters + '.' + 3 characters). The path is not recorded.</p>
  ///
  /// When using this tag, audio files shall be recorded in conformance to the Exif audio
  /// format. Writers can also store the data such as Audio within APP2 as Flashpix extension
  /// stream data. Audio files shall be recorded in conformance to the Exif audio format.
  final String RelatedSoundFile;

  /// The date and time when the original image data was generated. For a DSC the date and time
  /// the picture was taken are recorded. The format is "YYYY:MM:DD HH:MM:SS" with time shown in
  /// 24-hour format, and the date and time separated by one blank character ({@code 0x20}).
  /// When the date and time are unknown, all the character spaces except colons (":") should be
  /// filled with blank characters, or else the Interoperability field should be filled with blank
  /// characters. When the field is left blank, it is treated as unknown.
  final String DateTimeOriginal;

  /// The date and time when the image was stored as digital data. If, for example, an image
  /// was captured by DSC and at the same time the file was recorded, then
  /// {@link #TAG_DATETIME_ORIGINAL} and this tag will have the same contents. The format is
  /// "YYYY:MM:DD HH:MM:SS" with time shown in 24-hour format, and the date and time separated by
  /// one blank character ({@code 0x20}). When the date and time are unknown, all the character
  /// spaces except colons (":")should be filled with blank characters, or else
  /// the Interoperability field should be filled with blank characters. When the field is left
  /// blank, it is treated as unknown.
  final String DateTimeDigitized;

  /// A tag used to record fractions of seconds for {@link #TAG_DATETIME}.
  final String SubSecTime;

  /// A tag used to record fractions of seconds for {@link #TAG_DATETIME_ORIGINAL}.
  final String SubSecTimeOriginal;

  /// A tag used to record fractions of seconds for {@link #TAG_DATETIME_DIGITIZED}.
  final String SubSecTimeDigitized;

  /// Exposure time, given in seconds.
  final double ExposureTime;

  /// The F number.
  final double FNumber;

  /// The class of the program used by the camera to set exposure when the picture is taken.
  /// The tag values are as follows.
  final int ExposureProgram;

  /// Indicates the spectral sensitivity of each channel of the camera used. The tag value is
  /// an ASCII string compatible with the standard developed by the ASTM Technical committee.
  final String SpectralSensitivity;

  /// This tag indicates the sensitivity of the camera or input device when the image was shot.
  /// More specifically, it indicates one of the following values that are parameters defined in
  /// ISO 12232: standard output sensitivity (SOS), recommended exposure index (REI), or ISO
  /// speed. Accordingly, if a tag corresponding to a parameter that is designated by
  /// {@link #TAG_SENSITIVITY_TYPE} is recorded, the values of the tag and of this tag are
  /// the same. However, if the value is 65535 or higher, the value of this tag shall be 65535.
  /// When recording this tag, {@link #TAG_SENSITIVITY_TYPE} should also be recorded. In addition,
  /// while “Count = Any”, only 1 count should be used when recording this tag.
  final int PhotographicSensitivity;

  /// Indicates the Opto-Electric Conversion Function (OECF) specified in ISO 14524. OECF is
  /// the relationship between the camera optical input and the image values.
  final String OECF;

  /// This tag indicates which one of the parameters of ISO12232 is
  /// {@link #TAG_PHOTOGRAPHIC_SENSITIVITY}. Although it is an optional tag, it should be recorded
  /// when {@link #TAG_PHOTOGRAPHIC_SENSITIVITY} is recorded.
  final int SensitivityType;

  /// This tag indicates the standard output sensitivity value of a camera or input device
  /// defined in ISO 12232. When recording this tag, {@link #TAG_PHOTOGRAPHIC_SENSITIVITY} and
  /// {@link #TAG_SENSITIVITY_TYPE} shall also be recorded.
  final double StandardOutputSensitivity;

  /// This tag indicates the recommended exposure index value of a camera or input device
  /// defined in ISO 12232. When recording this tag, {@link #TAG_PHOTOGRAPHIC_SENSITIVITY} and
  /// {@link #TAG_SENSITIVITY_TYPE} shall also be recorded.
  final double RecommendedExposureIndex;

  /// This tag indicates the ISO speed value of a camera or input device that is defined in
  /// ISO 12232. When recording this tag, {@link #TAG_PHOTOGRAPHIC_SENSITIVITY} and
  /// {@link #TAG_SENSITIVITY_TYPE} shall also be recorded.
  final double ISOSpeed;

  /// This tag indicates the ISO speed latitude yyy value of a camera or input device that is
  /// defined in ISO 12232. However, this tag shall not be recorded without {@link #TAG_ISO_SPEED}
  /// and {@link #TAG_ISO_SPEED_LATITUDE_ZZZ}.
  final double ISOSpeedLatitudeyyy;

  /// This tag indicates the ISO speed latitude zzz value of a camera or input device that is
  /// defined in ISO 12232. However, this tag shall not be recorded without {@link #TAG_ISO_SPEED}
  /// and {@link #TAG_ISO_SPEED_LATITUDE_YYY}.
  final double ISOSpeedLatitudezzz;

  /// Shutter speed. The unit is the APEX setting.
  final double ShutterSpeedValue;

  /// The lens aperture. The unit is the APEX value.
  final double ApertureValue;

  /// The value of brightness. The unit is the APEX value. Ordinarily it is given in the range
  /// of -99.99 to 99.99. Note that if the numerator of the recorded value is 0xFFFFFFFF,
  /// Unknown shall be indicated.
  final double BrightnessValue;

  /// The exposure bias. The unit is the APEX value. Ordinarily it is given in the range of
  /// -99.99 to 99.99.
  final double ExposureBiasValue;

  /// The smallest F number of the lens. The unit is the APEX value. Ordinarily it is given
  /// in the range of 00.00 to 99.99, but it is not limited to this range.
  final double MaxApertureValue;

  /// The distance to the subject, given in meters. Note that if the numerator of the recorded
  /// value is 0xFFFFFFFF, Infinity shall be indicated; and if the numerator is 0, Distance
  /// unknown shall be indicated.
  final double SubjectDistance;

  /// The metering mode.
  final int MeteringMode;

  /// The kind of light source.
  final int LightSource;

  /// This tag indicates the status of flash when the image was shot. Bit 0 indicates the flash
  /// firing status, bits 1 and 2 indicate the flash return status, bits 3 and 4 indicate
  /// the flash mode, bit 5 indicates whether the flash function is present, and bit 6 indicates
  /// "red eye" mode.
  final int Flash;

  /// This tag indicates the location and area of the main subject in the overall scene.
  final List<int> SubjectArea;

  /// The actual focal length of the lens, in mm. Conversion is not made to the focal length
  /// of a 35mm film camera.
  final double FocalLength;

  /// Indicates the strobe energy at the time the image is captured, as measured in Beam Candle
  /// Power Seconds (BCPS).
  final double FlashEnergy;

  /// This tag records the camera or input device spatial frequency table and SFR values in
  /// the direction of image width, image height, and diagonal direction, as specified in
  /// ISO 12233.
  final String SpatialFrequencyResponse;

  /// Indicates the number of pixels in the image width (X) direction per
  /// {@link #TAG_FOCAL_PLANE_RESOLUTION_UNIT} on the camera focal plane.
  final double FocalPlaneXResolution;

  /// Indicates the number of pixels in the image height (Y) direction per
  /// {@link #TAG_FOCAL_PLANE_RESOLUTION_UNIT} on the camera focal plane.
  final double FocalPlaneYResolution;

  /// Indicates the unit for measuring {@link #TAG_FOCAL_PLANE_X_RESOLUTION} and
  /// {@link #TAG_FOCAL_PLANE_Y_RESOLUTION}. This value is the same as
  /// {@link #TAG_RESOLUTION_UNIT}.
  final int FocalPlaneResolutionUnit;

  /// Indicates the location of the main subject in the scene. The value of this tag represents
  /// the pixel at the center of the main subject relative to the left edge, prior to rotation
  /// processing as per {@link #TAG_ORIENTATION}. The first value indicates the X column number
  /// and second indicates the Y row number. When a camera records the main subject location,
  /// it is recommended that {@link #TAG_SUBJECT_AREA} be used instead of this tag.
  final int SubjectLocation;

  /// Indicates the exposure index selected on the camera or input device at the time the image
  /// is captured.
  final double ExposureIndex;

  /// Indicates the image sensor type on the camera or input device.
  final int SensingMethod;

  /// Indicates the image source. If a DSC recorded the image, this tag value always shall
  /// be set to {@link #FILE_SOURCE_DSC}.
  final String FileSource;

  /// Indicates the type of scene. If a DSC recorded the image, this tag value shall always
  /// be set to {@link #SCENE_TYPE_DIRECTLY_PHOTOGRAPHED}.
  final String SceneType;

  /// Indicates the color filter array (CFA) geometric pattern of the image sensor when
  /// a one-chip color area sensor is used. It does not apply to all sensing methods.
  final String CFAPattern;

  /// This tag indicates the use of special processing on image data, such as rendering geared
  /// to output. When special processing is performed, the Exif/DCF reader is expected to disable
  /// or minimize any further processing.
  final int CustomRendered;

  /// This tag indicates the exposure mode set when the image was shot.
  /// In {@link #EXPOSURE_MODE_AUTO_BRACKET}, the camera shoots a series of frames of the same
  /// scene at different exposure settings.
  final int ExposureMode;

  /// This tag indicates the white balance mode set when the image was shot.
  final int WhiteBalance;

  /// This tag indicates the digital zoom ratio when the image was shot. If the numerator of
  /// the recorded value is 0, this indicates that digital zoom was not used.
  final double DigitalZoomRatio;

  /// This tag indicates the equivalent focal length assuming a 35mm film camera, in mm.
  /// A value of 0 means the focal length is unknown. Note that this tag differs from
  /// {@link #TAG_FOCAL_LENGTH}.
  final int FocalLengthIn35mmFilm;

  /// This tag indicates the type of scene that was shot. It may also be used to record
  /// the mode in which the image was shot. Note that this differs from
  /// {@link #TAG_SCENE_TYPE}.
  final int SceneCaptureType;

  /// This tag indicates the degree of overall image gain adjustment.
  final int GainControl;

  /// This tag indicates the direction of contrast processing applied by the camera when
  /// the image was shot.
  final int Contrast;

  /// This tag indicates the direction of saturation processing applied by the camera when
  /// the image was shot.
  final int Saturation;

  /// This tag indicates the direction of sharpness processing applied by the camera when
  /// the image was shot.
  final int Sharpness;

  /// This tag indicates information on the picture-taking conditions of a particular camera
  /// model. The tag is used only to indicate the picture-taking conditions in the Exif/DCF
  /// reader.
  final String DeviceSettingDescription;

  /// This tag indicates the distance to the subject.
  final int SubjectDistanceRange;

  /// This tag indicates an identifier assigned uniquely to each image. It is recorded as
  /// an ASCII string equivalent to hexadecimal notation and 128-bit fixed length.
  final String ImageUniqueID;

  ExifMetadata(
    this.ImageWidth,
    this.ImageLength,
    this.BitsPerSample,
    this.Compression,
    this.PhotometricInterpretation,
    this.Orientation,
    this.SamplesPerPixel,
    this.PlanarConfiguration,
    this.YCbCrSubSampling,
    this.YCbCrPositioning,
    this.XResolution,
    this.YResolution,
    this.ResolutionUnit,
    this.StripOffsets,
    this.RowsPerStrip,
    this.StripByteCounts,
    this.JPEGInterchangeFormat,
    this.JPEGInterchangeFormatLength,
    this.TransferFunction,
    this.WhitePoint,
    this.PrimaryChromaticities,
    this.YCbCrCoefficients,
    this.ReferenceBlackWhite,
    this.DateTime,
    this.ImageDescription,
    this.Artist,
    this.Copyright,
    this.ExifVersion,
    this.FlashpixVersion,
    this.ColorSpace,
    this.Gamma,
    this.PixelXDimension,
    this.PixelYDimension,
    this.ComponentsConfiguration,
    this.CompressedBitsPerPixel,
    this.UserComment,
    this.RelatedSoundFile,
    this.DateTimeOriginal,
    this.DateTimeDigitized,
    this.SubSecTime,
    this.SubSecTimeOriginal,
    this.SubSecTimeDigitized,
    this.ExposureTime,
    this.FNumber,
    this.ExposureProgram,
    this.SpectralSensitivity,
    this.PhotographicSensitivity,
    this.OECF,
    this.SensitivityType,
    this.StandardOutputSensitivity,
    this.RecommendedExposureIndex,
    this.ISOSpeed,
    this.ISOSpeedLatitudeyyy,
    this.ISOSpeedLatitudezzz,
    this.ShutterSpeedValue,
    this.ApertureValue,
    this.BrightnessValue,
    this.ExposureBiasValue,
    this.MaxApertureValue,
    this.SubjectDistance,
    this.MeteringMode,
    this.LightSource,
    this.Flash,
    this.SubjectArea,
    this.FocalLength,
    this.FlashEnergy,
    this.SpatialFrequencyResponse,
    this.FocalPlaneXResolution,
    this.FocalPlaneYResolution,
    this.FocalPlaneResolutionUnit,
    this.SubjectLocation,
    this.ExposureIndex,
    this.SensingMethod,
    this.FileSource,
    this.SceneType,
    this.CFAPattern,
    this.CustomRendered,
    this.ExposureMode,
    this.WhiteBalance,
    this.DigitalZoomRatio,
    this.FocalLengthIn35mmFilm,
    this.SceneCaptureType,
    this.GainControl,
    this.Contrast,
    this.Saturation,
    this.Sharpness,
    this.DeviceSettingDescription,
    this.SubjectDistanceRange,
    this.ImageUniqueID,
  );

  ExifMetadata.fromMap(Map json)
      : ImageWidth = _castAsDouble(json['ImageWidth'] ?? null),
        ImageLength = _castAsDouble(json['ImageLength'] ?? null),
        BitsPerSample = _castAsInt(json['BitsPerSample'] ?? null),
        Compression = _castAsInt(json['Compression'] ?? null),
        PhotometricInterpretation =
            _castAsInt(json['PhotometricInterpretation'] ?? null),
        Orientation = _castAsInt(json['Orientation'] ?? null),
        SamplesPerPixel = _castAsInt(json['SamplesPerPixel'] ?? null),
        PlanarConfiguration = _castAsInt(json['PlanarConfiguration'] ?? null),
        YCbCrSubSampling = _castAsInt(json['YCbCrSubSampling'] ?? null),
        YCbCrPositioning = _castAsInt(json['YCbCrPositioning'] ?? null),
        XResolution = _castAsDouble(json['XResolution'] ?? null),
        YResolution = _castAsDouble(json['YResolution'] ?? null),
        ResolutionUnit = _castAsInt(json['ResolutionUnit'] ?? null),
        StripOffsets = _castAsDouble(json['StripOffsets'] ?? null),
        RowsPerStrip = _castAsDouble(json['RowsPerStrip'] ?? null),
        StripByteCounts = _castAsDouble(json['StripByteCounts'] ?? null),
        JPEGInterchangeFormat =
            _castAsDouble(json['JPEGInterchangeFormat'] ?? null),
        JPEGInterchangeFormatLength =
            _castAsDouble(json['JPEGInterchangeFormatLength'] ?? null),
        TransferFunction = _castAsInt(json['TransferFunction'] ?? null),
        WhitePoint = _castAsDouble(json['WhitePoint'] ?? null),
        PrimaryChromaticities =
            _castAsDouble(json['PrimaryChromaticities'] ?? null),
        YCbCrCoefficients = _castAsDouble(json['YCbCrCoefficients'] ?? null),
        ReferenceBlackWhite =
            _castAsDouble(json['ReferenceBlackWhite'] ?? null),
        DateTime = _castAsString(json['DateTime'] ?? null),
        ImageDescription = _castAsString(json['ImageDescription'] ?? null),
        Artist = _castAsString(json['Artist'] ?? null),
        Copyright = _castAsString(json['Copyright'] ?? null),
        ExifVersion = _castAsString(json['ExifVersion'] ?? null),
        FlashpixVersion = _castAsString(json['FlashpixVersion'] ?? null),
        ColorSpace = _castAsInt(json['ColorSpace'] ?? null),
        Gamma = _castAsDouble(json['Gamma'] ?? null),
        PixelXDimension = _castAsDouble(json['PixelXDimension'] ?? null),
        PixelYDimension = _castAsDouble(json['PixelYDimension'] ?? null),
        ComponentsConfiguration =
            _castAsString(json['ComponentsConfiguration'] ?? null),
        CompressedBitsPerPixel =
            _castAsDouble(json['CompressedBitsPerPixel'] ?? null),
        UserComment = _castAsString(json['UserComment'] ?? null),
        RelatedSoundFile = _castAsString(json['RelatedSoundFile'] ?? null),
        DateTimeOriginal = _castAsString(json['DateTimeOriginal'] ?? null),
        DateTimeDigitized = _castAsString(json['DateTimeDigitized'] ?? null),
        SubSecTime = _castAsString(json['SubSecTime'] ?? null),
        SubSecTimeOriginal = _castAsString(json['SubSecTimeOriginal'] ?? null),
        SubSecTimeDigitized =
            _castAsString(json['SubSecTimeDigitized'] ?? null),
        ExposureTime = _castAsDouble(json['ExposureTime'] ?? null),
        FNumber = _castAsDouble(json['FNumber'] ?? null),
        ExposureProgram = _castAsInt(json['ExposureProgram'] ?? null),
        SpectralSensitivity =
            _castAsString(json['SpectralSensitivity'] ?? null),
        PhotographicSensitivity =
            _castAsInt(json['PhotographicSensitivity'] ?? null),
        OECF = _castAsString(json['OECF'] ?? null),
        SensitivityType = _castAsInt(json['SensitivityType'] ?? null),
        StandardOutputSensitivity =
            _castAsDouble(json['StandardOutputSensitivity'] ?? null),
        RecommendedExposureIndex =
            _castAsDouble(json['RecommendedExposureIndex'] ?? null),
        ISOSpeed = _castAsDouble(json['ISOSpeed'] ?? null),
        ISOSpeedLatitudeyyy =
            _castAsDouble(json['ISOSpeedLatitudeyyy'] ?? null),
        ISOSpeedLatitudezzz =
            _castAsDouble(json['ISOSpeedLatitudezzz'] ?? null),
        ShutterSpeedValue = _castAsDouble(json['ShutterSpeedValue'] ?? null),
        ApertureValue = _castAsDouble(json['ApertureValue'] ?? null),
        BrightnessValue = _castAsDouble(json['BrightnessValue'] ?? null),
        ExposureBiasValue = _castAsDouble(json['ExposureBiasValue'] ?? null),
        MaxApertureValue = _castAsDouble(json['MaxApertureValue'] ?? null),
        SubjectDistance = _castAsDouble(json['SubjectDistance'] ?? null),
        MeteringMode = _castAsInt(json['MeteringMode'] ?? null),
        LightSource = _castAsInt(json['LightSource'] ?? null),
        Flash = _castAsInt(json['Flash'] ?? null),
        SubjectArea = _castAsIntMap(json['SubjectArea'] ?? null),
        FocalLength = _castAsDouble(json['FocalLength'] ?? null),
        FlashEnergy = _castAsDouble(json['FlashEnergy'] ?? null),
        SpatialFrequencyResponse =
            _castAsString(json['SpatialFrequencyResponse'] ?? null),
        FocalPlaneXResolution =
            _castAsDouble(json['FocalPlaneXResolution'] ?? null),
        FocalPlaneYResolution =
            _castAsDouble(json['FocalPlaneYResolution'] ?? null),
        FocalPlaneResolutionUnit =
            _castAsInt(json['FocalPlaneResolutionUnit'] ?? null),
        SubjectLocation = _castAsInt(json['SubjectLocation'] ?? null),
        ExposureIndex = _castAsDouble(json['ExposureIndex'] ?? null),
        SensingMethod = _castAsInt(json['SensingMethod'] ?? null),
        FileSource = _castAsString(json['FileSource'] ?? null),
        SceneType = _castAsString(json['SceneType'] ?? null),
        CFAPattern = _castAsString(json['CFAPattern'] ?? null),
        CustomRendered = _castAsInt(json['CustomRendered'] ?? null),
        ExposureMode = _castAsInt(json['ExposureMode'] ?? null),
        WhiteBalance = _castAsInt(json['WhiteBalance'] ?? null),
        DigitalZoomRatio = _castAsDouble(json['DigitalZoomRatio'] ?? null),
        FocalLengthIn35mmFilm =
            _castAsInt(json['FocalLengthIn35mmFilm'] ?? null),
        SceneCaptureType = _castAsInt(json['SceneCaptureType'] ?? null),
        GainControl = _castAsInt(json['GainControl'] ?? null),
        Contrast = _castAsInt(json['Contrast'] ?? null),
        Saturation = _castAsInt(json['Saturation'] ?? null),
        Sharpness = _castAsInt(json['Sharpness'] ?? null),
        DeviceSettingDescription =
            _castAsString(json['DeviceSettingDescription'] ?? null),
        SubjectDistanceRange = _castAsInt(json['SubjectDistanceRange'] ?? null),
        ImageUniqueID = _castAsString(json['ImageUniqueID'] ?? null);
}

class GpsMetadata {
  /// Indicates the version of GPS Info IFD. The version is given as 2.3.0.0. This tag is
  /// mandatory when GPS-related tags are present. Note that this tag is written as a different
  /// byte than {@link #TAG_EXIF_VERSION}.
  final String GPSVersionID;

  /// Indicates whether the latitude is north or south latitude.
  final String GPSLatitudeRef;

  /// Indicates the latitude. The latitude is expressed as three RATIONAL values giving
  /// the degrees, minutes, and seconds, respectively. If latitude is expressed as degrees,
  /// minutes and seconds, a typical format would be dd/1,mm/1,ss/1. When degrees and minutes are
  /// used and, for example, fractions of minutes are given up to two decimal places, the format
  /// would be dd/1,mmmm/100,0/1.
  final double GPSLatitude;

  /// Indicates whether the longitude is east or west longitude.
  final String GPSLongitudeRef;

  /// Indicates the longitude. The longitude is expressed as three RATIONAL values giving
  /// the degrees, minutes, and seconds, respectively. If longitude is expressed as degrees,
  /// minutes and seconds, a typical format would be ddd/1,mm/1,ss/1. When degrees and minutes
  /// are used and, for example, fractions of minutes are given up to two decimal places,
  /// the format would be ddd/1,mmmm/100,0/1.
  final double GPSLongitude;

  /// Indicates the altitude used as the reference altitude. If the reference is sea level
  /// and the altitude is above sea level, 0 is given. If the altitude is below sea level,
  /// a value of 1 is given and the altitude is indicated as an absolute value in
  /// {@link #TAG_GPS_ALTITUDE}
  final String GPSAltitudeRef;

  /// Indicates the altitude based on the reference in {@link #TAG_GPS_ALTITUDE_REF}.
  /// The reference unit is meters.
  final double GPSAltitude;

  /// Indicates the time as UTC (Coordinated Universal Time). TimeStamp is expressed as three
  /// unsigned rational values giving the hour, minute, and second.
  final String GPSTimeStamp;

  /// Indicates the GPS satellites used for measurements. This tag may be used to describe
  /// the number of satellites, their ID number, angle of elevation, azimuth, SNR and other
  /// information in ASCII notation. The format is not specified. If the GPS receiver is incapable
  /// of taking measurements, value of the tag shall be set to {@code null}.
  final String GPSSatellites;

  /// Indicates the status of the GPS receiver when the image is recorded. 'A' means
  /// measurement is in progress, and 'V' means the measurement is interrupted.
  final String GPSStatus;

  /// Indicates the GPS measurement mode. Originally it was defined for GPS, but it may
  /// be used for recording a measure mode to record the position information provided from
  /// a mobile base station or wireless LAN as well as GPS.
  final String GPSMeasureMode;

  /// Indicates the GPS DOP (data degree of precision). An HDOP value is written during
  /// two-dimensional measurement, and PDOP during three-dimensional measurement.
  final double GPSDOP;

  /// Indicates the unit used to express the GPS receiver speed of movement.
  final String GPSSpeedRef;

  /// Indicates the speed of GPS receiver movement.
  final double GPSSpeed;

  /// Indicates the reference for giving the direction of GPS receiver movement.
  final String GPSTrackRef;

  /// Indicates the direction of GPS receiver movement.
  /// The range of values is from 0.00 to 359.99.
  final double GPSTrack;

  /// Indicates the reference for giving the direction of the image when it is captured.
  final String GPSImgDirectionRef;

  /// Indicates the direction of the image when it was captured.
  final double GPSImgDirection;

  /// Indicates the geodetic survey data used by the GPS receiver. If the survey data is
  /// restricted to Japan,the value of this tag is 'TOKYO' or 'WGS-84'. If a GPS Info tag is
  /// recorded, it is strongly recommended that this tag be recorded.
  final String GPSMapDatum;

  /// Indicates whether the latitude of the destination point is north or south latitude.
  final String GPSDestLatitudeRef;

  /// Indicates the latitude of the destination point. The latitude is expressed as three
  /// unsigned rational values giving the degrees, minutes, and seconds, respectively.
  /// If latitude is expressed as degrees, minutes and seconds, a typical format would be
  /// dd/1,mm/1,ss/1. When degrees and minutes are used and, for example, fractions of minutes
  /// are given up to two decimal places, the format would be dd/1, mmmm/100, 0/1.
  final double GPSDestLatitude;

  /// Indicates whether the longitude of the destination point is east or west longitude.
  final String GPSDestLongitudeRef;

  /// Indicates the longitude of the destination point. The longitude is expressed as three
  /// unsigned rational values giving the degrees, minutes, and seconds, respectively.
  /// If longitude is expressed as degrees, minutes and seconds, a typical format would be ddd/1,
  /// mm/1, ss/1. When degrees and minutes are used and, for example, fractions of minutes are
  /// given up to two decimal places, the format would be ddd/1, mmmm/100, 0/1.
  final double GPSDestLongitude;

  /// Indicates the reference used for giving the bearing to the destination point.
  final String GPSDestBearingRef;

  /// Indicates the bearing to the destination point.
  /// The range of values is from 0.00 to 359.99.
  final double GPSDestBearing;

  /// Indicates the unit used to express the distance to the destination point.
  final String GPSDestDistanceRef;

  /// Indicates the distance to the destination point.
  final double GPSDestDistance;

  /// A character string recording the name of the method used for location finding.
  /// The first byte indicates the character code used, and this is followed by the name of
  /// the method.
  final String GPSProcessingMethod;

  /// A character string recording the name of the GPS area. The first byte indicates
  /// the character code used, and this is followed by the name of the GPS area.
  final String GPSAreaInformation;

  /// A character string recording date and time information relative to UTC (Coordinated
  /// Universal Time). The format is "YYYY:MM:DD".
  final String GPSDateStamp;

  /// Indicates whether differential correction is applied to the GPS receiver.
  final int GPSDifferential;

  /// This tag indicates horizontal positioning errors in meters.
  final double GPSHPositioningError;

  /// Indicates the identification of the Interoperability rule.
  final String InteroperabilityIndex;

  GpsMetadata(
    this.GPSVersionID,
    this.GPSLatitudeRef,
    this.GPSLatitude,
    this.GPSLongitudeRef,
    this.GPSLongitude,
    this.GPSAltitudeRef,
    this.GPSAltitude,
    this.GPSTimeStamp,
    this.GPSSatellites,
    this.GPSStatus,
    this.GPSMeasureMode,
    this.GPSDOP,
    this.GPSSpeedRef,
    this.GPSSpeed,
    this.GPSTrackRef,
    this.GPSTrack,
    this.GPSImgDirectionRef,
    this.GPSImgDirection,
    this.GPSMapDatum,
    this.GPSDestLatitudeRef,
    this.GPSDestLatitude,
    this.GPSDestLongitudeRef,
    this.GPSDestLongitude,
    this.GPSDestBearingRef,
    this.GPSDestBearing,
    this.GPSDestDistanceRef,
    this.GPSDestDistance,
    this.GPSProcessingMethod,
    this.GPSAreaInformation,
    this.GPSDateStamp,
    this.GPSDifferential,
    this.GPSHPositioningError,
    this.InteroperabilityIndex,
  );

  GpsMetadata.fromMap(Map json)
      : GPSVersionID = _castAsString(json['GPSVersionID'] ?? null),
        GPSLatitudeRef = _castAsString(json['GPSLatitudeRef'] ?? null),
        GPSLatitude = _castAsDouble(json['GPSLatitude'] ?? null),
        GPSLongitudeRef = _castAsString(json['GPSLongitudeRef'] ?? null),
        GPSLongitude = _castAsDouble(json['GPSLongitude'] ?? null),
        GPSAltitudeRef = _castAsString(json['GPSAltitudeRef'] ?? null),
        GPSAltitude = _castAsDouble(json['GPSAltitude'] ?? null),
        GPSTimeStamp = _castAsString(json['GPSTimeStamp'] ?? null),
        GPSSatellites = _castAsString(json['GPSSatellites'] ?? null),
        GPSStatus = _castAsString(json['GPSStatus'] ?? null),
        GPSMeasureMode = _castAsString(json['GPSMeasureMode'] ?? null),
        GPSDOP = _castAsDouble(json['GPSDOP'] ?? null),
        GPSSpeedRef = _castAsString(json['GPSSpeedRef'] ?? null),
        GPSSpeed = _castAsDouble(json['GPSSpeed'] ?? null),
        GPSTrackRef = _castAsString(json['GPSTrackRef'] ?? null),
        GPSTrack = _castAsDouble(json['GPSTrack'] ?? null),
        GPSImgDirectionRef = _castAsString(json['GPSImgDirectionRef'] ?? null),
        GPSImgDirection = _castAsDouble(json['GPSImgDirection'] ?? null),
        GPSMapDatum = _castAsString(json['GPSMapDatum'] ?? null),
        GPSDestLatitudeRef = _castAsString(json['GPSDestLatitudeRef'] ?? null),
        GPSDestLatitude = _castAsDouble(json['GPSDestLatitude'] ?? null),
        GPSDestLongitudeRef =
            _castAsString(json['GPSDestLongitudeRef'] ?? null),
        GPSDestLongitude = _castAsDouble(json['GPSDestLongitude'] ?? null),
        GPSDestBearingRef = _castAsString(json['GPSDestBearingRef'] ?? null),
        GPSDestBearing = _castAsDouble(json['GPSDestBearing'] ?? null),
        GPSDestDistanceRef = _castAsString(json['GPSDestDistanceRef'] ?? null),
        GPSDestDistance = _castAsDouble(json['GPSDestDistance'] ?? null),
        GPSProcessingMethod =
            _castAsString(json['GPSProcessingMethod'] ?? null),
        GPSAreaInformation = _castAsString(json['GPSAreaInformation'] ?? null),
        GPSDateStamp = _castAsString(json['GPSDateStamp'] ?? null),
        GPSDifferential = _castAsInt(json['GPSDifferential'] ?? null),
        GPSHPositioningError =
            _castAsDouble(json['GPSHPositioningError'] ?? null),
        InteroperabilityIndex =
            _castAsString(json['InteroperabilityIndex'] ?? null);
}

class DeviceMetadata {
  /// The manufacturer of the recording equipment. This is the manufacturer of the DSC,
  /// scanner, video digitizer or other equipment that generated the image. When the field is left
  /// blank, it is treated as unknown.
  final String Make;

  /// The model name or model number of the equipment. This is the model name of number of
  /// the DSC, scanner, video digitizer or other equipment that generated the image. When
  /// the field is left blank, it is treated as unknown.
  final String Model;

  /// This tag records the name and version of the software or firmware of the camera or image
  /// input device used to generate the image. The detailed format is not specified, but it is
  /// recommended that the example shown below be followed. When the field is left blank, it is
  /// treated as unknown.
  final String Software;

  /// A  tag for Exif users to write keywords or comments on the image besides those in
  /// {@link #TAG_IMAGE_DESCRIPTION}, and without the character code limitations of it.
  final String MakerNote;

  /// This tag records the owner of a camera used in photography as an ASCII string.
  final String CameraOwnerName;

  /// This tag records the serial number of the body of the camera that was used in photography
  /// as an ASCII string.
  final String BodySerialNumber;

  /// This tag notes minimum focal length, maximum focal length, minimum F number in the
  /// minimum focal length, and minimum F number in the maximum focal length, which are
  /// specification information for the lens that was used in photography. When the minimum
  /// F number is unknown, the notation is 0/0.
  final List<double> LensSpecification;

  /// This tag records the lens manufacturer as an ASCII string.
  final String LensMake;

  /// This tag records the lens’s model name and model number as an ASCII string.
  final String LensModel;

  /// This tag records the serial number of the interchangeable lens that was used in
  /// photography as an ASCII string.
  final String LensSerialNumber;

  DeviceMetadata(
    this.Make,
    this.Model,
    this.Software,
    this.MakerNote,
    this.CameraOwnerName,
    this.BodySerialNumber,
    this.LensSpecification,
    this.LensMake,
    this.LensModel,
    this.LensSerialNumber,
  );

  DeviceMetadata.fromMap(Map json)
      : Make = _castAsString(json['Make'] ?? null),
        Model = _castAsString(json['Model'] ?? null),
        Software = _castAsString(json['Software'] ?? null),
        MakerNote = _castAsString(json['MakerNote'] ?? null),
        CameraOwnerName = _castAsString(json['CameraOwnerName'] ?? null),
        BodySerialNumber = _castAsString(json['BodySerialNumber'] ?? null),
        LensSpecification = _castAsDoubleMap(json['LensSpecification'] ?? null),
        LensMake = _castAsString(json['LensMake'] ?? null),
        LensModel = _castAsString(json['LensModel'] ?? null),
        LensSerialNumber = _castAsString(json['LensSerialNumber'] ?? null);
}

int _castAsInt(dynamic variable) {
  if (variable == null) {
    return null;
  }

  if (variable is double) {
    return variable.toInt();
  }

  return (!(variable is int)) ? int.parse(variable.toString()) : variable;
}

double _castAsDouble(dynamic variable) {
  if (variable == null) {
    return null;
  }

  if (variable is int) {
    return variable.toDouble();
  }
  return (!(variable is double)) ? double.parse(variable.toString()) : variable;
}

String _castAsString(dynamic variable) {
  if (variable == null) {
    return null;
  }

  if (variable is List) {
    return variable.join('');
  }

  return (!(variable is String)) ? variable.toString() : variable;
}

List<int> _castAsIntMap(List<dynamic> list) {
  if (list == null) {
    return null;
  }

  return list.map<int>((n) => _castAsInt(n)).toList();
}

List<double> _castAsDoubleMap(List<dynamic> list) {
  if (list == null) {
    return null;
  }

  return list.map<double>((n) => _castAsDouble(n)).toList();
}
