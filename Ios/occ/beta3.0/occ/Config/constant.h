//
//  Constants.h
//  RS_CRM_Client
//
//  Created by RS on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define SCREEN_HEIGHT               [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH                [[UIScreen mainScreen] bounds].size.width
#define HEADER_HEIGHT               44
#define FOOTER_HEIGHT               49
#define TABBAR_HEIGHT               49
#define SEARCH_WIDTH                320
#define SEARCH_HEIGHT               44
#define LEFTVIEW_WIDTH              266

#define SHOP_BASEINFO_HEIGHT  90

#define SECOND_LAUNCH @"secondLaunch"

#define OCC_USER_NAME @"occ_user_name"
#define OCC_USER_PASSWORD @"occ_user_password"
#define OCC_MAC_ADDR @"occ_mac_addr"

#define PAGE_SIZE  10

#define MAC_ADDR @"ACF7F34076EE"

#define POWERLONG_WIFI_SSID  @"IPOWERLONG"

#define SUCCESS_IMAGE_FILE          @"success.png"
#define FAILURE_IMAGE_FILE          @"fail.png"

#define kAlpha   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define kAlphaNumber  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define kNumber  @"0123456789"
#define kNumberPoint  @"0123456789."
#define kPhone  @"0123456789-"

#define REFRESH_TIME_INTERVAL  0

#define kMaxWords 200
#define KEEP_ALIVE_TIME_INTERVAL  30
#define TIME_OUT_TIME_INTERVAL  10
#define HTTP_METHOD_POST @"POST"
#define HTTP_METHOD_SET  @"SET"
#define HTTP_METHOD_GET  @"GET"
#define HTTP_KEY_CONTENTTYPE  @"Content-Type"
#define HTTP_KEY_DATA  @"data"

#define  MIN_PRICE @"0"
#define  MAX_PRICE @"100000"

#define MD5_KEY @"APWMFIVJDAUVCHWOQQFDVB"   // 用作签名
#define DES_KEY @"CXSOKJTSQSAZCVGHGHVDSDCG" //用作对称加密、解密

#define IOS7_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

/*
 // 如果定义了NeedFailDialog这个宏，说明需要错误信息
 */
//#define NeedFailDialog

#define APP_ID @"732970431"
#define APP_DOWNLOAD_URL @"http://itunes.apple.com/lookup?id=732970431"
#define APP_SCORE_URL @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=732970431"

//#define  OCC_IP                    @"http://192.168.171.112:8080"
//#define  OCC_IP                    @"http://plocc.powerlong.com"
#define  OCC_IP                      @"http://www.ipowerlong.com"

#define  MAP_IP                  @"http://locate.ipowerlong.com"

#define  GATEWAY_IP                OCC_IP

#define  UNIPAY_TYPE         0   //0:正式  1:测试

#define  login_URL                   OCC_IP@"/OCC_SSO_Web/mobile.htm"
#define  egisterMobileNo_URL  OCC_IP@"/userWeb/userMobileCenter/registerMobileNo.htm"
#define  register_URL  OCC_IP@"/userWeb/userMobileCenter/register.htm"
#define  newRegister_URL  OCC_IP@"/userWeb/userMobileCenter/newRegister.htm"

#define  getMallInfo_URL  OCC_IP@"/userWeb/userMobileCenter/getMallInfo.htm"

#define  unReadNumsMobile_URL    OCC_IP@"/userWeb/userMobileCenter/unReadNumsMobile.htm"
#define  loadOrderCount_URL    OCC_IP@"/tradeWeb/mobile/loadOrderCount.htm"

#define  storeListMobile_URL    OCC_IP@"/userWeb/userMobileCenter/storeListMobile.htm"
#define  mobileRemoveStoreFavour_URL    OCC_IP@"/userWeb/userMobileCenter/mobileRemoveStoreFavour.htm"
#define  mobileRemoveItemFavour_URL    OCC_IP@"/userWeb/userMobileCenter/mobileRemoveItemFavour.htm"
#define  itemListMobile_URL    OCC_IP@"/userWeb/userMobileCenter/itemListMobile.htm"
#define  addItemsCart_URL    OCC_IP@"/userWeb/userMobileCenter/addItemsCart.htm"
#define  messageListMobile_URL    OCC_IP@"/userWeb/userMobileCenter/messageListMobile.htm"
#define  loadMessage_URL    OCC_IP@"/userWeb/userMobileCenter/loadMessage.htm"
#define  updateMsgRead_URL    OCC_IP@"/userWeb/userMobileCenter/updateMsgRead.htm"
#define  notifyListMobile_URL    OCC_IP@"/userWeb/userMobileCenter/notifyListMobile.htm"
#define  updateNotifyRead_URL    OCC_IP@"/userWeb/userMobileCenter/updateNotifyRead.htm"

#define  loadCashCouponList_URL    OCC_IP@"/userWeb/userMobileCenter/loadCashCouponList.htm"

#define  loadOrderList_URL    OCC_IP@"/tradeWeb/mobile/loadOrderList.htm" //订单列表
#define  loadOrderListByStat_URL   OCC_IP@"/tradeWeb/mobile/loadOrderListByStat.htm" //订单列表
#define  loadParentOrder_URL    OCC_IP@"/tradeWeb/mobile/loadParentOrder.htm"  //查看主订单
#define  loadOrder_URL    OCC_IP@"/tradeWeb/mobile/loadOrder.htm"  //查看订单

#define  shopCashCouponListMobile_URL    OCC_IP@"/userWeb/userMobileCenter/shopCashCouponListMobile.htm"
#define  shopGrouponListMobile_URL    OCC_IP@"/userWeb/userMobileCenter/shopGrouponListMobile.htm"
#define  deleteShopInFavour_URL    OCC_IP@"/userWeb/userMobileCenter/deleteShopInFavour.htm"  //在收藏店铺中删除店铺
#define  addItemsCart_URL    OCC_IP@"/userWeb/userMobileCenter/addItemsCart.htm"  //商品进入购物车
#define  itemBuy_URL    OCC_IP@"/tradeWeb/mobile/itemBuy.htm"  //商品进入购物车

#define  grouponList_URL   OCC_IP@"/grouponWeb/mobile/grouponList.htm"   //团购列表
#define  loadGroupon_URL   OCC_IP@"/grouponWeb/mobile/loadGroupon.htm" //团购详情
#define  grouponItemList_URL   OCC_IP@"/grouponWeb/mobile/grouponItemList.htm"  //团购商品列表
#define  grouponCommentList_URL  OCC_IP@"/grouponWeb/mobile/grouponCommentList.htm"  //团购评论

#define  loadItem_URL   OCC_IP@"/shopWeb/mobile/loadItem.htm"  //商品详情
#define  itemCommentList_URL   OCC_IP@"/shopWeb/mobile/itemCommentList.htm"  //商品评论

#define  loadCart_URL  OCC_IP@"/tradeWeb/mobile/loadCart.htm"  //获得购物车信息
#define  gotoCount_URL  OCC_IP@"/tradeWeb/mobile/gotoCount.htm" //进入结算
#define  addOrder_URL  OCC_IP@"/tradeWeb/mobile/addOrder.htm"  //下订单
#define  loadPlCashCoupon_URL  OCC_IP@"/shopWeb/mobile/loadPlCashCoupon.htm"
#define  findAllAddress_URL  OCC_IP@"/userWeb/userMobileCenter/findAllAddress.htm"  //收货地址列表
#define  findAddressById_URL  OCC_IP@"/userWeb/userMobileCenter/findAddressById.htm"  //收货地址查看
#define  deleteAddress_URL  OCC_IP@"/userWeb/userMobileCenter/deleteAddress.htm"  //收货地址删除
#define  defaultAddress_URL  OCC_IP@"/userWeb/userMobileCenter/defaultAddress.htm"  //收货地址设置默认
#define  addAddress_URL  OCC_IP@"/userWeb/userMobileCenter/addAddress.htm"
#define  changeItemNum_URL  OCC_IP@"/tradeWeb/mobile/changeItemNum.htm"
#define  addItemFavour_URL  OCC_IP@"/userWeb/userMobileCenter/addItemFavour.htm"
#define  deleteItem_URL  OCC_IP@"/tradeWeb/mobile/deleteItem.htm"

#define  sendMessage_URL  OCC_IP@"/userWeb/userMobileCenter/sendMessage.htm"  //发言

#define  loadShop_URL  OCC_IP@"/shopWeb/mobile/loadShop.htm"  //读取店铺下的商品列表
#define  loadShopItemDetail_URL  OCC_IP@"/shopWeb/mobile/loadShopItemDetail.htm"  //读取店铺下的商品列表

#define  pictureHandle_URL    OCC_IP@"/shopWeb/mobile/pictureHandle.htm"  //处理图片缩放接口

#define  orderRecv_URL   OCC_IP@"/tradeWeb/mobile/orderRecv.htm"  //确认收货

#define  loadCommunity_URL   OCC_IP@"/userWeb/userMobileCenter/loadCommunity.htm"  //读取区域信息

#define  orderPay_URL   OCC_IP@"/tradeWeb/mobile/orderPay.htm"  // 通过主订单编号,获取支付单号

#define  qq_URL   OCC_IP@"/OCC_SSO_Web/mobile/connect/callback/qq.htm"

#define  appLogin_URL   OCC_IP@"/OCC_SSO_Web/appLogin.htm"

#define  favourShop_URL   OCC_IP@"/userWeb/userMobileCenter/favourShop.htm"
#define  mobileAddItemFavour_URL   OCC_IP@"/userWeb/userMobileCenter/mobileAddItemFavour.htm"

#define  itemFavourList_URL   OCC_IP@"/userWeb/userMobileCenter/itemFavourList.htm"

#define  search_URL            MAP_IP@"/locate_web/location/search.htm"  //
#define  searchByInfo_URL      MAP_IP@"/locate_web/location/searchByInfo.htm"  //
#define  searchShopInfo_URL    MAP_IP@"/locate_web/shopInfo/searchShopInfo.htm"  //
#define  getShopInfo_URL       MAP_IP@"/locate_web/shopInfo/getShopInfo.htm"  //
#define  searchByShopId_URL    MAP_IP@"/locate_web/location/searchByShopId.htm"  //
#define  getWifiProp_URL       MAP_IP@"/locate_web/location/getWifiProp.htm"  //

#define  accessSerial_URL   GATEWAY_IP@"/OCC_GATEWAY_Web/service/access_serial.htm"  //
#define  prepare_URL GATEWAY_IP@"/OCC_GATEWAY_Web/pay/prepare.htm"  //
#define  toChannel_URL   GATEWAY_IP@"/OCC_GATEWAY_Web/pay/toChannel.htm"  //
#define  queryAppCode_URL   GATEWAY_IP@"/OCC_GATEWAY_Web/common/queryAppCode.htm"  //


#define  validateOpenSms_URL   OCC_IP@"/userWeb/userMobileCenter/validateOpenSms.htm"  //
#define  registerMobileNo_URL   OCC_IP@"/userWeb/userMobileCenter/registerMobileNo.htm"  //
#define  modifyUserInfo_URL   OCC_IP@"/userWeb/userMobileCenter/modifyUserInfo.htm"  //

#define  acitivityList_URL   OCC_IP@"/shopWeb/mobile/acitivityList.htm"  //
#define  loadActivity_URL   OCC_IP@"/shopWeb/mobile/loadActivity.htm"  //

typedef enum
{
    AlertTagAlipax = 1000,
    AlertTagNewVersion,
    AlertTagpPaySucces,
    AlertTagpPayFail,
} AlertTagType;

typedef enum {
    SortTypeUp,
    SortTypeDown,
    SortTypeOther
}SortType;

typedef enum {
    NavTypeFloor=1,
    NavTypeBrand,
    NavTypeActivity,
    NavTypeFood,
    NavTypeEntertainment,
    NavTypeBuy,
    NavTypeGroupon,
}NavType;

typedef enum {
    LastOrderTypeNormal,//普通订单
    LastOrderTypeGroupon,//团购订单
}LastOrderType;

typedef NS_ENUM(NSInteger,OCCBizType)
{
    OCCBizPay=1,   //支付
    OCCBizDrawback, //退款
};

typedef NS_ENUM(NSInteger,OCCSearchClassiFication)
{
    OCCSearchClassiFicationKeyWord,   //搜索建议
    OCCSearchClassiFicationShop,      //店铺搜索
    OCCSearchClassiFicationItem,      //商品搜索
    OCCSearchClassiFicationOther
};

typedef NS_ENUM(NSInteger,OCCFavoriteFrom)
{
    OCCFavoriteFromCart,   //搜索建议
    OCCFavoriteFromOther,      //店铺搜索
};

typedef NS_ENUM(NSInteger, CommentType)
{
    CommentTypeAll,//
    CommentTypeOther,//
};

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define COLOR_0072BB    [UIColor colorWithRed:0x00/255.0 green:0x72/255.0 blue:0xBB/255.0 alpha:1]
#define COLOR_449139    [UIColor colorWithRed:0x44/255.0 green:0x91/255.0 blue:0x39/255.0 alpha:1]
#define COLOR_F46614    [UIColor colorWithRed:0xF4/255.0 green:0x66/255.0 blue:0x14/255.0 alpha:1]
#define COLOR_FF0000    [UIColor colorWithRed:0xFF/255.0 green:0x00/255.0 blue:0x00/255.0 alpha:1]
#define COLOR_AC2727    [UIColor colorWithRed:0xAC/255.0 green:0x27/255.0 blue:0x27/255.0 alpha:1]
#define COLOR_E4E7EC    [UIColor colorWithRed:0xE4/255.0 green:0xE7/255.0 blue:0xEC/255.0 alpha:1]
#define COLOR_CBCBCB    [UIColor colorWithRed:0xCB/255.0 green:0xCB/255.0 blue:0xCB/255.0 alpha:1]
#define COLOR_666666    [UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1]
#define COLOR_333333    [UIColor colorWithRed:0x33/255.0 green:0x33/255.0 blue:0x33/255.0 alpha:1]
#define COLOR_FFFFFF    [UIColor colorWithRed:0xFF/255.0 green:0xFF/255.0 blue:0xFF/255.0 alpha:1]
#define COLOR_7C8692    [UIColor colorWithRed:0x7c/255.0 green:0x86/255.0 blue:0x92/255.0 alpha:1]
#define COLOR_696969    [UIColor colorWithRed:0x69/255.0 green:0x69/255.0 blue:0x69/255.0 alpha:1]
#define COLOR_C11016    [UIColor colorWithRed:0xc1/255.0 green:0x10/255.0 blue:0x16/255.0 alpha:1]
#define COLOR_BEBEBE    [UIColor colorWithRed:0xbe/255.0 green:0xbe/255.0 blue:0xbe/255.0 alpha:1]
#define COLOR_E3E3E3    [UIColor colorWithRed:0xe3/255.0 green:0xe3/255.0 blue:0xe3/255.0 alpha:1]
#define COLOR_F4A435    [UIColor colorWithRed:0xF4/255.0 green:0xA4/255.0 blue:0x35/255.0 alpha:1]
#define COLOR_F9F9F9    [UIColor colorWithRed:0xF9/255.0 green:0xF9/255.0 blue:0xF9/255.0 alpha:1]
#define COLOR_403B3F    [UIColor colorWithRed:0x40/255.0 green:0x3B/255.0 blue:0x3F/255.0 alpha:1]
#define COLOR_3F3B3E    [UIColor colorWithRed:0x3F/255.0 green:0x3B/255.0 blue:0x3E/255.0 alpha:1]

#define COLOR_000000    [UIColor colorWithRed:0x00/255.0 green:0x00/255.0 blue:0x00/255.0 alpha:1]
#define COLOR_CBED69    [UIColor colorWithRed:0xCB/255.0 green:0xED/255.0 blue:0x69/255.0 alpha:1]
#define COLOR_453D3A    [UIColor colorWithRed:0x45/255.0 green:0x3D/255.0 blue:0x3A/255.0 alpha:1]
#define COLOR_8A7A74    [UIColor colorWithRed:0x8A/255.0 green:0x7A/255.0 blue:0x74/255.0 alpha:1]
#define COLOR_D76437    [UIColor colorWithRed:0xD7/255.0 green:0x64/255.0 blue:0x37/255.0 alpha:1]
#define COLOR_DA6432    [UIColor colorWithRed:0xDA/255.0 green:0x64/255.0 blue:0x32/255.0 alpha:1]
#define COLOR_EAEAEA    [UIColor colorWithRed:0xEA/255.0 green:0xEA/255.0 blue:0xEA/255.0 alpha:1]
#define COLOR_F3F3F3    [UIColor colorWithRed:0xF3/255.0 green:0xF3/255.0 blue:0xF3/255.0 alpha:1]
#define COLOR_FFF9E2    [UIColor colorWithRed:0xFF/255.0 green:0xF9/255.0 blue:0xE2/255.0 alpha:1]
#define COLOR_F1F1F1    [UIColor colorWithRed:0xF1/255.0 green:0xF1/255.0 blue:0xF1/255.0 alpha:1]
#define COLOR_FAB731    [UIColor colorWithRed:0xFA/255.0 green:0xB7/255.0 blue:0x31/255.0 alpha:1]
#define COLOR_FBB714    [UIColor colorWithRed:0xFB/255.0 green:0xB7/255.0 blue:0x14/255.0 alpha:1]
#define COLOR_2A7F3C    [UIColor colorWithRed:0x2A/255.0 green:0x7F/255.0 blue:0x3C/255.0 alpha:1]
#define COLOR_AA6506    [UIColor colorWithRed:0xAA/255.0 green:0x65/255.0 blue:0x06/255.0 alpha:1]
#define COLOR_CCCCCC    [UIColor colorWithRed:0xCC/255.0 green:0xCC/255.0 blue:0xCC/255.0 alpha:1]
#define COLOR_2E7D3F    [UIColor colorWithRed:0x2E/255.0 green:0x7D/255.0 blue:0x3F/255.0 alpha:1]
#define COLOR_165B24    [UIColor colorWithRed:0x16/255.0 green:0x5B/255.0 blue:0x24/255.0 alpha:1]
#define COLOR_594F47    [UIColor colorWithRed:0x59/255.0 green:0x4F/255.0 blue:0x47/255.0 alpha:1]
#define COLOR_D1BEB0    [UIColor colorWithRed:0xD1/255.0 green:0xBE/255.0 blue:0xB0/255.0 alpha:1]
#define COLOR_26221F    [UIColor colorWithRed:0x26/255.0 green:0x22/255.0 blue:0x1F/255.0 alpha:1]
#define COLOR_74665B    [UIColor colorWithRed:0x74/255.0 green:0x66/255.0 blue:0x5B/255.0 alpha:1]
#define COLOR_FABE00    [UIColor colorWithRed:0xFA/255.0 green:0xBE/255.0 blue:0x00/255.0 alpha:1]
#define COLOR_1F391D    [UIColor colorWithRed:0x1F/255.0 green:0x39/255.0 blue:0x1D/255.0 alpha:1]

#define COLOR_F3EFEC    [UIColor colorWithRed:0xF3/255.0 green:0xEF/255.0 blue:0xEC/255.0 alpha:1]

#define COLOR_999999    [UIColor colorWithRed:0x99/255.0 green:0x99/255.0 blue:0x99/255.0 alpha:1]
#define COLOR_A6978D    [UIColor colorWithRed:0xA6/255.0 green:0x97/255.0 blue:0x8D/255.0 alpha:1]
#define COLOR_CCB6A3    [UIColor colorWithRed:0xCC/255.0 green:0xB6/255.0 blue:0xA3/255.0 alpha:1]
#define COLOR_27813A    [UIColor colorWithRed:0x27/255.0 green:0x81/255.0 blue:0x3A/255.0 alpha:1]
#define COLOR_D91F1E    [UIColor colorWithRed:0xD9/255.0 green:0x1F/255.0 blue:0x1E/255.0 alpha:1]
#define COLOR_27813A    [UIColor colorWithRed:0x27/255.0 green:0x81/255.0 blue:0x3A/255.0 alpha:1]
#define COLOR_FFF6DA    [UIColor colorWithRed:0xFF/255.0 green:0xF6/255.0 blue:0xDA/255.0 alpha:1]

#define COLOR_5F5E5D    [UIColor colorWithRed:0x5F/255.0 green:0x5E/255.0 blue:0x5D/255.0 alpha:1]

#define COLOR_44853F    [UIColor colorWithRed:0x44/255.0 green:0x85/255.0 blue:0x3F/255.0 alpha:1]

#define COLOR_BG_CLASSONE [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_section_gray"]]
#define COLOR_BG_CLASSTWO [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_class_two"]]
#define COLOR_BG_CLASSTHREE [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_class_three"]]
#define COLOR_BG_CLASSFOUR [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_transparent_60"]]
#define COLOR_BG_CLASS5 [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_pattern"]]

#define COLOR_CELL_LINE_CLASS1 [UIColor colorWithPatternImage:[UIImage imageNamed:@"line1"]]
#define COLOR_CELL_LINE_CLASS2 [UIColor colorWithPatternImage:[UIImage imageNamed:@"line2"]]
#define COLOR_CELL_LINE_CLASS3 [UIColor colorWithPatternImage:[UIImage imageNamed:@"line3"]]
#define COLOR_CELL_LINE_CLASS4 [UIColor colorWithPatternImage:[UIImage imageNamed:@"line_navi"]]

#define FONT_8  [UIFont systemFontOfSize: 8.0]
#define FONT_10 [UIFont systemFontOfSize: 10.0]
#define FONT_12 [UIFont systemFontOfSize: 12.0]
#define FONT_13 [UIFont systemFontOfSize: 13.0]
#define FONT_14 [UIFont systemFontOfSize: 14.0]
#define FONT_BOLD_14 [UIFont boldSystemFontOfSize: 14.0]
#define FONT_16 [UIFont systemFontOfSize: 16.0]
#define FONT_BOLD_16 [UIFont boldSystemFontOfSize: 16.0]
#define FONT_18 [UIFont systemFontOfSize: 18.0]
#define FONT_BOLD_18 [UIFont boldSystemFontOfSize: 18.0]
#define FONT_20 [UIFont systemFontOfSize: 20.0]
#define FONT_BOLD_20 [UIFont boldSystemFontOfSize:20.0]
#define FONT_22 [UIFont systemFontOfSize: 22.0]
#define FONT_BOLD_22 [UIFont boldSystemFontOfSize:22.0]
#define FONT_30 [UIFont systemFontOfSize: 30.0]
#define FONT_40 [UIFont systemFontOfSize: 40.0]
#define FONT_52 [UIFont systemFontOfSize: 52.0]

#define kBargainLabelWidth 280

#define  MAX_MSG_WIDTH 230

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088211222587392"
//收款支付宝账号
#define SellerID  @"fz_plmall@powerlong.com"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define ALIPAY_MD5_KEY @"grtcr9pmxculu89av17gm4jg17x79fj2"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBANVeFsAeisE6zol7TBwWooWhzdHQswVI7De2+8Z5KICAV1Dc7QU2SwNMO7X1i4IXUvNbkx9G0CYEsEnJhNnFCkTXnTa/jIzC/qvdCRjhdkauaV0wHZK4HjGvcXh06qzIV5xAIMlBfNn3nDtafUf6k1JeiQo9YgdYdm5/0t8M1DWRAgMBAAECgYAutZFPb6A6mvAaAsbvozji/j/7fa+jKYqky8ckdOOb9fyndCXjLTaQu0CbHezzhr2fDt4PS8ZHfGFHVfliXxNXBmtt8nUWHvahJzIjRz2lFclE7BdBz4qDDFAq9vYEWbVBLZDf2w8aE8XWbNCCXgSuq/X52xtet+eulnq4MWtEPQJBAO/7/spcw0IScxXoQ9IbH9FIZCajZn40OnBiyXeIcQ0TCibKmIZpJZJutRgQtYx1l2h13BibBqVAu0WGhSQp3SsCQQDjm1wA6MKGoxjlC+lJpujHWnzJYV9DGPkIphkezgm0EO8MeHpaokV7iYWR3USa/dTuCKfn6MiT1XYqIGicAHIzAkEAoaeLv+Cwnqcy4sTsOnGPAzjSTbyv479mxiGlOGGuVXJH2k2KZLAbYQI19pn60Ty82t7ZfbGfzl1GSNUOhoe0tQJBAJTnH8KshA7HBtNZ/o4jtugs57RrkoH4BXxGBeskSi7WYT2cWBeRT7mpV4v84RQw+aucWBSdMxOcNAkNWMKufAcCQQDW2gLFfTwFdN9viAY5NUprPqZPPUnWpClJcu+g38tPEyJH+vO5ZQt51YXLd6qa4eMYt6GanXdY5RYGouTGC4sI"


//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"
