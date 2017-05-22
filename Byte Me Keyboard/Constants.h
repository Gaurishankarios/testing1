//
//  Constants.h
//
//
//  Created by Leandro Marques on 16/06/2014.
//  Copyright (c) 2014 NetDevo Limited. All rights reserved.
//

#ifndef bytemeapp_Constants_h
#define bytemeapp_Constants_h


#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]


#define COVER_SIZE ([NSString stringWithFormat:@"cover%dx", ((int)[UIScreen mainScreen].scale)])
//#define ASSET_SIZE(asset) ([NSString stringWithFormat:@"%@@%dx",asset, ((int)[UIScreen mainScreen].scale)])
#define COVER_SIZE_SMALL @"cover1x"



#define tileBorderRadius 10.0f
#define cellSpacingConst 170.0f//177.5f
#define cellWidthConst 240.0f
#define cellHeightConst 258.0f


#define fadeSpeed 0.3f
#define tileBorderRadiusSmall 5.0f
#define copyingDelay 1.0f
#define savedDelay 1.0f
#define autoHideDelay 3.0f
#define SCREEN_HEIGHT ( [[UIScreen mainScreen] bounds].size.height - 44 - [UIApplication sharedApplication].statusBarFrame.size.height)
#define SCREEN_HEIGHT_FULL ( [[UIScreen mainScreen] bounds].size.height - [UIApplication sharedApplication].statusBarFrame.size.height)

#define SCREEN_WIDTH ( [[UIScreen mainScreen] bounds].size.width)


// APP
#define APP_STORE_ID @"991321798"



// CASOURSEL
#define carouselTime 4.0f


// ANALYTICS
#define trackingID @""//@"UA-62525925-1"
#define trackingVerbose NO
#define MIXPANEL_TOKEN @"1178b07e337654a490d382c5f7c65c27"


// APIS
#define API_URL @"https://d1lymbzb4c45ju.cloudfront.net/" // dev
//#define API_URL @"https://api.bytemeapp.co/" //live @"https://d1fcyvmq7qn9ae.cloudfront.net/"

#define ASSET_URL @"https://d1bu85kg251dc.cloudfront.net/" // dev
//#define ASSET_URL @"https://cdn.bytemeapp.co/"

#define SEARCH_URL @"https://search-byteme-app-search-dev-tgykmgqvj7sxpz2p6t7m3a5z5m.eu-west-1.cloudsearch.amazonaws.com/" // dev
//#define SEARCH_URL @"https://search-byteme-app-search-mxlfttkntjys6ijnhxerchsrh4.eu-west-1.cloudsearch.amazonaws.com/"


// STYLES
#define myBytesColor UIColorFromRGB(0x999999)
#define myBytesBackgroundColor UIColorFromRGB(0xfbfbfb)

#define myFavouritesBackgroundColor UIColorFromRGB(0xfbfbfb)
#define thumbKeyboardTransitionTime 0.1f
#define platSelectionFadeSpeed 0.1f
#define keyboardKeyBorderRadius 5.0f
#define keyboardKeyFontSize 17.0f
#define keyboardKeyLabelColor UIColorFromRGB(0x333333)
#define keyboardKeyLabelDisabledColor UIColorFromRGB(0x77777F)

#define keyboardKeyBorderWidth 0.5f
#define keyboardImageKeyBackgroundColor UIColorFromRGB(0x99999F)
#define keyboardSuggesterCellHeight 32.0f
#define keyboardSuggesterCellFontSize 13.0f

#define keyboardAlphaNumericFontSize 24.0f
#define keyboardCursorFadeTime 0.5f


#define keyboardButtonHighlightColor UIColorFromRGB(0x999999)

#define mainBkgColor UIColorFromRGB(0xBBBDBF) //ADB4BD
#define cellShadowColor UIColorFromRGB(0x878A8E)
#define platSelectedColor UIColorFromRGBA(0x000000, 0.5f) //UIColorFromRGB(0x000000)
#define platSelectedColorOverlay UIColorFromRGBA(0x000000, 0.5f)

#define clearCcolor [UIColor whiteColor]

#define coverThumbBorderThickness 0.0f
#define coverThumbBorderColor UIColorFromRGB(0xDDDDDD)
#define coverThumbBorderRadius 10.0f
#define coverThumbBackgroundColor UIColorFromRGB(0xDDDDDD)

#define categorySeparatorColor UIColorFromRGB(0xEEEEEE)
#define categorySeparatorMargin 8.0f
#define categoryLabelColor UIColorFromRGB(0x666666 ) //UIColorFromRGB(0x999999)

#define navigationLabelColor UIColorFromRGB(0x666666 ) //UIColorFromRGB(0x999999)
#define navigationBarTintColor UIColorFromRGB(0xEC257B)

#define globalBackgroundColor UIColorFromRGB(0xFFFFFF)

#define linkTintColor UIColorFromRGB(0xEC257B)

#define recentBytesColor UIColorFromRGB(0xbb002c)
#define recentBytesBackgroundColor UIColorFromRGB(0xfee7e7)


#define footerLabelColor UIColorFromRGB(0x666666)
#define footerFontSize 30.0f
#define footerArrowFontSize 25.0f


#define messageLabelColor UIColorFromRGB(0x999999)
#define messageLabelFontSize 30.0f

#define messageButtonLabelColour UIColorFromRGB(0xEC257B)
#define messageButtonBackgroundColour UIColorFromRGB(0xEFEFEF)


#define footerCellHeight 60.0f
#define footerBackgroundColor UIColorFromRGB(0xEFEFEF)

#define featuredCellHeight 130.0f
#define headerCelltHeight 154.0f//154.0f // 160

#define gridCellPadding 10.0f
#define gridThumbBorderRadius 10.0f
#define gridLabelColor UIColorFromRGB(0x666666)


#define thumbTransitionTime 0.2f
#define defaultTimeOutResponse 60

#define carouselthumbTransitionTime 0.2f
#define carouselTransitionTime 0.5f
#define carouselBackgroundColor UIColorFromRGB(0xDDDDDD)

#define refreshControlBackgroundColor UIColorFromRGB(0xEC257B)
#define refreshControlTintColor UIColorFromRGB(0xFFFFFF)

#define byteLabelColor UIColorFromRGB(0x444444)
#define copyTextColor UIColorFromRGB(0x666666)

#define legalsFontSize 15.0f


#define byteImagePadding 10.0f
#define byteTitleCellHeight 44.0f
#define byteArrowCellHeight 30.0f
#define byteDescriptionHeight 41.0f
#define byteTipCellHeight 30.0f

#define byteDescBackgroundBorderRadius 5.0f
#define byteDescBackgroundColor UIColorFromRGBA(0xFFFFFF, 0.5f)
#define byteTipBackgroundColor UIColorFromRGBA(0xFFFFFF, 0.3f)

#define byteAddButtonBackgroundColor UIColorFromRGB(0xEC257B)
#define byteAddButtonTintColor UIColorFromRGB(0xFFFFFF)
#define byteAddButtonCellHeight 80.0f
#define byteAddButtonBorderRadius 27.0f
#define byteAddButtonFontSize 30.0f
#define byteAddButtonInstalledBackgroundColor UIColorFromRGB(0xEC257B)
#define byteAddBorderWidth 1.0f

#define byteStatusBackgroundColor UIColorFromRGB(0xFFFFFF)

#define similarLabelColor UIColorFromRGB(0x444444)
#define myByteThumbDisbaledColour UIColorFromRGBA(0xEC257B, 0.5f)
#define myByteDisbaledAlpha 0.3f
#define myByteDisbaledScale 0.4f


#define myBytesLabelFontSize 24.0f
#define myBytesCountFontSize 60.0f
#define myBytesLabelColor UIColorFromRGB(0x666666)
#define myBytesLabelBrightColor UIColorFromRGB(0xAAAAAA)
#define myBytesHeaderCellHeight 200.0f

#define seeAllLabel @"SEE ALL >"
#define seeAllLabelFontSize 15.0f
#define categoryLabelFontSize 17.0f


#define searchSuggestionBackgroundColor UIColorFromRGB(0xFFFFFF)
#define searchSuggestionLabelColor UIColorFromRGB(0x666666)
#define searchSuggestionLabelFontSize 17.0f
#define searchSuggestionCelltHeight 50.0f
#define searchSuggestionTipCelltHeight 80.0f
#define searchSuggestionMargin 8.0f
#define searchSuggestionHeaderBackgroundColor UIColorFromRGB(0xEEEEEE)
#define searchSuggestionHeaderLabelColor UIColorFromRGB(0x333333)
#define searchSuggestionHeaderIconColor UIColorFromRGB(0x999999)
#define searchSuggestionHeaderCelltHeight 40.0f



#define tutorialTitleTextColor UIColorFromRGB(0xFFFFFF)
#define tutorialTitleTextFontSize 28.0f
#define tutorialTitleSmallerTextFontSize 24.0f

#define tutorialSubTitleTextColor UIColorFromRGB(0xFFFFFF)
#define tutorialSubTitleTextFontSize 18.0f

#define tutorialButtonBackgroundColour UIColorFromRGB(0xFFFFFF)
#define tutorialButtonLabelColour UIColorFromRGB(0x333333)
#define tutorialButtonBorderRadius 10.0f
#define tutorialButtonFontSize 20.0f


// MENU STYLES
#define menuSeparatorColor UIColorFromRGB(0xDDDDDD)
#define menuLabelColor UIColorFromRGB(0x999999) // 666666
#define menuSubLabelColor UIColorFromRGB(0x666666) 
#define menuBackgroundColor UIColorFromRGB(0xFFFFFF)
#define menuSubBackgroundColor UIColorFromRGB(0xF8F8F8)

#define menuSeparatorThickness 1.0f
#define menuSeparatorMargin 16.0f
#define menuIconColor UIColorFromRGB(0x999999)
#define menuLeftIconColor UIColorFromRGB(0x999999)



// DW TAG LIST STYLES

#define DW_CORNER_RADIUS 8.0f
#define DW_LABEL_MARGIN_DEFAULT 8.0f
#define DW_BOTTOM_MARGIN_DEFAULT 8.0f
#define DW_FONT_SIZE_DEFAULT 17.0f
#define DW_HORIZONTAL_PADDING_DEFAULT 8.0f
#define DW_VERTICAL_PADDING_DEFAULT 5.0f
#define DW_BACKGROUND_COLOR UIColorFromRGBA(0xF8F8F8, 1.0f)
#define DW_TEXT_COLOR UIColorFromRGB(0x666666)
#define DW_TEXT_SHADOW_COLOR UIColorFromRGBA(0xFFFFFF, 0.0f)
#define DW_TEXT_SHADOW_OFFSET CGSizeMake(0.0f, 1.0f)
#define DW_BORDER_COLOR UIColorFromRGBA(0xFFFFFF, 0.0f)
#define DW_BORDER_WIDTH 0.0f
#define DW_HIGHLIGHTED_BACKGROUND_COLOR UIColorFromRGBA(0xF8F8F8, 0.5f)
#define DW_DEFAULT_AUTOMATIC_RESIZE NO
#define DW_DEFAULT_SHOW_TAG_MENU NO


// FEEDBACK

#define feedbackEmailAddress @"hello@bytemeapp.co"
#define feedbackSubject @"Hello!"


#endif
