//
//  YDInterfaceDefinition.h
//  StandardApplication
//
//  Created on 2020/3/13.
//  Copyright © 2020 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef YDInterfaceDefinition_h
#define YDInterfaceDefinition_h


// 公共接口
// Api正式环境
//static NSString *const BaseURL = @"https://alpha.huichenghuijia.com/user";
//static NSString *const BaseApiURL = @"https://alpha.huichenghuijia.com";
//static NSString *const HardwareBaseURL = @"https://alpha.huichenghuijia.com/user/hardware";
//static NSString *const ReleaseBaseURL = @"https://alpha.huichenghuijia.com/release";

// Api测试环境
static NSString *const BaseURL = @"http://beta.fujuhaofang.com/user";
static NSString *const BaseApiURL = @"http://beta.fujuhaofang.com";
static NSString *const HardwareBaseURL = @"http://beta.fujuhaofang.com/user/hardware";
static NSString *const ReleaseBaseURL = @"http://beta.fujuhaofang.com/release";

// 后台测试环境
//static NSString *const BaseURL = @"http://pre.fujuhaofang.com/user";
//static NSString *const BaseApiURL = @"http://pre.fujuhaofang.com";
//static NSString *const HardwareBaseURL = @"http://pre.fujuhaofang.com/user/hardware";
//static NSString *const ReleaseBaseURL = @"http://pre.fujuhaofang.com/release";

/// 用户协议
static NSString *const User_Protocol_URL = @"https://appweb.huichenghuijia.com/#/app/articleDetail?articleId=106";
/// 隐私政策
static NSString *const Private_Protocol_URL = @"https://appweb.huichenghuijia.com/#/app/articleDetail?articleId=107";

/// 版本号接口
static NSString *const Version_indexURL = @"/Version/index";
/// 发送登录验证码
static NSString *const login_smsURL = @"/login/sms";
/// 手机用户-登录
static NSString *const login_appURL = @"/login/app";
/// 手机用户-密码登录
static NSString *const login_pwdURL = @"/login/pwd";
/// 手机用户-登出
static NSString *const login_logoutURL = @"/setting/logout";
/// 用户详情数据
static NSString *const setting_profileURL = @"/setting/profile";
/// 文件上传 图片
static NSString *const upload_indexURL = @"/upload/index";
/// 文件上传pdf
static NSString *const upload_fileURL = @"/upload/file";
/// Banner 列表
static NSString *const banner_listURL = @"/banner/list";
/// 首页-专题接口
static NSString *const special_listURL = @"/Special/index";
/// 首页-专题推文详情接口
static NSString *const special_detailURL = @"/Special/detail";
/// 房源-列表
static NSString *const unit_indexURL = @"/unit/index";
/// 地图房源-列表
static NSString *const unit_listings_mapURL = @"/unit/listings_map";
/// 特色-列表
static NSString *const basic_pointsURL = @"/basic/points";
/// 小区分类-列表
static NSString *const unit_tabIndexURL = @"/unit/tabIndex";
/// 房源-检索
static NSString *const unit_filterJsonURL = @"/unit/filterJson";
/// 获取区县
static NSString *const basic_countyURL = @"/basic/county_all";
/// 获取城镇
static NSString *const basic_townURL = @"/basic/town_all";
/// 获取区县
static NSString *const basic_county_noAllURL = @"/basic/county";
/// 获取城镇
static NSString *const basic_town_noAllURL = @"/basic/town";
/// 房源-详情
static NSString *const unit_detailURL = @"/unit/detail";
/// 房源-收藏
static NSString *const unit_collectURL = @"/unit/collect";
/// 房源-取消收藏
static NSString *const unit_cancelcollectURL = @"/unit/cancel";
/// 收藏列表
static NSString *const operate_subscribeURL = @"/operate/subscribe";
/// 全局预定金设定
static NSString *const setting_get_resURL = @"/setting/get_res";
/// 预定录入接口
static NSString *const reserve_applyURL = @"/reserve/apply";
/// 预定支付宝下单
static NSString *const reserve_alipayURL = @"/reserve/alipay";
/// 预定微信下单
static NSString *const reserve_wechatURL = @"/reserve/wechat";
/// 房源-预约
static NSString *const operate_bookURL = @"/operate/book";
/// 憓家生活-首页
static NSString *const activity_homeURL = @"/activity/home";
/// 空间预约-列表
static NSString *const space_indexURL = @"/Space/index";
/// 空间预约接口
static NSString *const space_reservationURL = @"/Space/reservation";
/// 我的预约接口
static NSString *const space_my_appointmentURL = @"/Space/my_appointment";
/// 空间详情接口
static NSString *const space_detailURL = @"/Space/detail";
/// 取消空间预约接口
static NSString *const space_del_appointmentURL = @"/Space/del_appointment";
/// 活动列表
static NSString *const activity_listURL = @"/activity/list";
/// 活动详情
static NSString *const activity_infoURL = @"/activity/info";
/// 活动预约
static NSString *const activity_applyURL = @"/activity/apply";
/// 活动取消
static NSString *const activity_revokeURL = @"/activity/revoke";
/// 消息列表
static NSString *const appMessage_indexURL = @"/AppMessage/index";
/// 消息已读
static NSString *const appMessage_click_onURL = @"/AppMessage/click_on";
/// 工单列表
static NSString *const workOrder_indexURL = @"/WorkOrder/index";
/// 工单聊天列表
static NSString *const workOrder_workOrderEvaluationListURL = @"/WorkOrder/workOrderEvaluationList";
/// 添加工单
static NSString *const workOrder_addTicketURL = @"/WorkOrder/addTicket";
/// 回复工单
static NSString *const workOrder_replyToATicketURL = @"/WorkOrder/replyToATicket";
/// 工单评价
static NSString *const workOrder_workOrderEvaluationURL = @"/WorkOrder/workOrderEvaluation";
/// 工单评价详情
static NSString *const workOrder_evaluationDetailURL = @"/WorkOrder/evaluationDetail";
/// 投诉建议类型
static NSString *const feedback_get_typesURL = @"/feedback/get_types";
/// 投诉建议
static NSString *const feedback_addURL = @"/feedback/add";
/// 业主委托
static NSString *const unit_entrustURL = @"/unit/entrust";
/// 资格申请须知
static NSString *const news_listURL = @"/news/list";
/// 我的预定列表
static NSString *const reserve_listURL = @"/reserve/list";
/// 我的预定详情
static NSString *const reserve_infoURL = @"/reserve/info";
/// 取消预订房源
static NSString *const reserve_revokeURL = @"/reserve/revoke";
/// 我的预约看房列表
static NSString *const operate_logURL = @"/operate/log";
/// 我的预约看房详情
static NSString *const operate_book_infoURL = @"/operate/book_info";
/// 取消预约看房
static NSString *const operate_brokenURL = @"/operate/broken";
/// 我的合同列表
static NSString *const contract_my_listURL = @"/contract/my_list";
/// 我的合同详情-预览
static NSString *const contract_previewURL = @"/contract/preview";
/// 续租-详情接口
static NSString *const reatRenew_reat_detailURL = @"/ReatRenew/reat_detail";
/// 续租-申请接口
static NSString *const reatRenew_reatURL = @"/ReatRenew/reat";
/// 退租-详情接口
static NSString *const reatRenew_renew_detailURL = @"/ReatRenew/renew_detail";
/// 退租-申请接口
static NSString *const reatRenew_renewURL = @"/ReatRenew/renew";
/// 我的账单-列表
static NSString *const bill_allURL = @"/bill/all";
/// 我的账单-详情
static NSString *const bill_detailURL = @"/bill/detail";
/// 我的账单-支付宝下单
static NSString *const bill_aliURL = @"/bill/ali";
/// 我的账单-微信下单
static NSString *const bill_wechatURL = @"/bill/wechat";
/// 我参与的活动-列表
static NSString *const activity_my_applyURL = @"/activity/my_apply";
/// 问题推荐
static NSString *const problem_hotURL = @"/problem/hot";
/// 问题搜索
static NSString *const problem_searchURL = @"/problem/search";
/// 问题详情
static NSString *const problem_detailURL = @"/problem/detail";
/// 获取 `app_key`
static NSString *const auth_base_appKeyURL = @"/auth/base/appKey";
/// 获取已经添加的硬件供应商列表
static NSString *const auth_user_get_added_providersURL = @"/auth/user/get_added_providers";
/// 获取硬件ID
static NSString *const device_common_get_devices_infoURL = @"/device/common/get_devices_info";
/// 获取电表信息
static NSString *const electric_meter_infoURL = @"/electric/meter/info";
/// 获取电表充值记录
static NSString *const event_record_ele_meter_recharge_recordURL = @"/event/record/ele_meter_recharge_record";
/// 获取水表充值记录
static NSString *const event_record_water_meter_recharge_recordURL = @"/event/record/water_meter_recharge_record";
/// 获取电表通断电记录
static NSString *const event_record_ele_meter_switch_recordURL = @"/event/record/ele_meter_switch_record";
/// 获取水表信息
static NSString *const water_meter_infoURL = @"/water/meter/info";
/// 最近读数及剩余水费
static NSString *const water_meter_amount_with_feesURL = @"/water/meter/amount_with_fees";
/// 电表充值
static NSString *const payment_initURL = @"/payment/init";
/// 获取门锁设备信息
static NSString *const lock_device_infoURL = @"/lock/key/get";
/// 获取门锁设备列表
static NSString *const lock_device_listingURL = @"/lock/device/listing";
/// 上传服务器最新开锁记录
static NSString *const lock_device_upload_open_recordsURL = @"/lock/device/upload_open_records";
/// 上传开锁失败原因
static NSString *const lock_error_recordsURL = @"/lock/error/record";
/// 门锁刷新状态
static NSString *const contract_refresh_statusURL = @"/contract/refresh_status";
/// 门锁刷新完成
static NSString *const contract_refresh_endURL = @"/contract/refresh_end";
/// 获取用户授权信息
static NSString *const lock_key_search_keyURL = @"/lock/key/search_key";
/// 生效中合同，用于生活费用中选择房源
static NSString *const contract_worksURL = @"/contract/works";
/// 法大大用户注册
static NSString *const faDada_registerURL = @"/FaDada/register";
/// 法大大电子合同签署
static NSString *const faDada_verify_signURL = @"/FaDada/verify_sign";
/// 房源-获取管家信息
static NSString *const unit_gethousekeeperURL = @"/unit/get_house_keeper";
/// 用户-业主委托-出租
static NSString *const unit_wantedURL = @"/unit/wanted";
/// 合同提醒-弹窗接口
static NSString *const appMessage_popupURL = @"/AppMessage/popup";
/// 合同提醒-关闭弹窗接口
static NSString *const appMessage_popup_readURL = @"/AppMessage/popup_read";
/// 用户-修改登录密码
static NSString *const setting_change_pwdURL = @"/setting/change_pwd";
/// 文章列表
static NSString *const news_get_infoURL = @"/news/get_info";
/// 文章列表
static NSString *const news_get_typesURL = @"/news/get_types";
/// 用户-提示(不再提示)
static NSString *const setting_not_againURL = @"/setting/not_again";
/// 云缴费支付切换
static NSString *const setting_switching_paymentURL = @"/Setting/switching_payment";
/// 云缴费拉起收银台
static NSString *const cloudPayCost_cloudPay_payURL = @"/api/CloudPayCost/CloudPay/pay";
/// 云缴费支付房源预定账单
static NSString *const cloudPay_reserve_payURL = @"/api/CloudPay/Reserve/pay";
/// 云缴费（水电费）拉起收银台
static NSString *const cloudPayCost_Recharge_payURL = @"/api/CloudPay/Recharge/pay";
/// 云缴费查询账单结果
static NSString *const cloudPayCost_cloudPay_getPaymentStatusURL = @"/api/CloudPayCost/CloudPay/getPaymentStatus";
/// 云缴费房源预定状态支付查询结果
static NSString *const cloudPay_reserve_statusURL = @"/api/CloudPay/Reserve/status";
/// 轮候政策列表
static NSString *const news_waitingListURL = @"/news/waitingList";
/// 轮候排队接口
static NSString *const unitWaiting_registerURL = @"/unitWaiting/register";
/// 轮候选房
static NSString *const unitWaiting_waitingURL = @"/unitWaiting/waiting";
/// 轮候详情
static NSString *const unitWaiting_infoURL = @"/unitWaiting/info";
/// 轮候取消
static NSString *const unitWaiting_cancelURL = @"/unitWaiting/cancel";
/// 匹配失败取消
static NSString *const unitWaiting_cancel_pickURL = @"/unitWaiting/cancel_pick";

/* 市级轮候相关 */
 
/// 轮候项目列表
static NSString *const cityWaiting_project_indexURL = @"/CityLevelWaitingProject/index";
/// 获取项目详情
static NSString *const cityWaiting_project_detailURL = @"/CityLevelWaitingProject/detail";
/// 轮候房型(对列)列表
static NSString *const cityWaiting_queue_indexURL = @"/CityLevelWaitingQueue/index";
/// 所有户型(对列)的名称
static NSString *const cityWaiting_queue_queueNameURL = @"/CityLevelWaitingQueue/queueName";
/// 获取户型详情
static NSString *const cityWaiting_house_detailURL = @"/CityLevelWaitingQueue/detail";
/// 获取轮候数据
static NSString *const cityWaiting_existURL = @"/CityLevelWaiting/exist";
/// 参与轮候
static NSString *const cityWaiting_attendURL = @"/CityLevelWaiting/attend";
/// 轮候放弃
static NSString *const cityWaiting_cancelURL = @"/CityLevelWaiting/cancel";
/// 再想想
static NSString *const cityWaiting_thinkAgainURL = @"/CityLevelWaiting/thinkAgain";
/// 意向签约
static NSString *const cityWaiting_signingURL = @"/CityLevelWaiting/signing";
/// 已参与轮候次数
static NSString *const cityWaiting_countURL = @"/CityLevelWaiting/count";
 
/// 公共房源库房源列表
static NSString *const house_listURL = @"/house/list";
/// 公共房源库房源详情
static NSString *const house_detailURL = @"/house/detail";

/// 账号注销接口
static NSString *const account_cancellationURL = @"/Setting/account_cancellation";
/// 账号注销详情
static NSString *const logout_detailURL = @"/Setting/logout_detail";

/// 获取融媒体中心新闻列表
static NSString *const news_ewdCloudListURL = @"/Release/News/ewdCloudList";

#pragma mark - 房源收购意向申报
/// 新增申报
static NSString *const acquisitionDeclaration_addURL = @"/AcquisitionDeclaration/add";
/// 修改申报
static NSString *const acquisitionDeclaration_updateURL = @"/acquisitionDeclaration/update";
/// 获取申报详情
static NSString *const acquisitionDeclaration_getURL = @"/acquisitionDeclaration/get";
/// 获取申报列表
static NSString *const acquisitionDeclaration_listURL = @"/acquisitionDeclaration/list";
/// 撤销申报
static NSString *const acquisitionDeclaration_cancelURL = @"/acquisitionDeclaration/cancel";
/// 获取申报数量
static NSString *const acquisitionDeclaration_countURL = @"/acquisitionDeclaration/count";
/// 获取申报进度
static NSString *const acquisitionDeclaration_progressURL = @"/acquisitionDeclaration/progress";

#pragma mark - 文件上传
/// 根据img_id获取文件信息
static NSString *const upload_infoURL = @"/upload/info";

#endif /* YDInterfaceDefinition_h */
