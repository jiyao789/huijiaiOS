# 新增申报接口

## OpenAPI Specification

```yaml
openapi: 3.0.1
info:
  title: ''
  description: ''
  version: 1.0.0
paths:
  /user/AcquisitionDeclaration/add:
    post:
      summary: 新增申报接口
      deprecated: false
      description: ''
      tags:
        - 用户端(小程序)/需要登录认证的/房源收购申报
      parameters: []
      requestBody:
        content:
          multipart/form-data:
            schema:
              type: object
              properties:
                declareTime:
                  description: 申报日期
                  example: '2026-10-15'
                  type: string
                requesterPhoneNum:
                  description: 申报人联系电话
                  example: '16765817658'
                  type: string
                requesterName:
                  description: 申报人姓名
                  example: 申报人
                  type: string
                address:
                  description: 不动产地址
                  example: 上海市
                  type: string
                ownerName:
                  description: 产权人姓名
                  example: 权利人姓名
                  type: string
                type:
                  description: 产权类型 1-商品房  2-公有住房出售  3-其他
                  example: 3
                  type: integer
                typeOther:
                  description: 其他类型输入
                  example: 自定义产权
                  type: string
                certificateNumber:
                  description: 产权证书编号
                  example: NO2121214397
                  type: string
                size:
                  description: 产权面积
                  example: 79.9
                  type: number
                ownershipType:
                  description: 共有情况  1-单独所有  2-共同所有   3-按份所有
                  example: 3
                  type: integer
                ownershipShare:
                  description: 份额比例
                  example: 张三10%25   李四90%25
                  type: string
                exceptionStatus:
                  description: 异议登记状况 1无异常  2有异常
                  example: 1
                  type: integer
                liveStatus:
                  description: 居住权状况  -无居住  2-有居住
                  example: 2
                  type: integer
                liveInfo:
                  description: 居住人姓名及期限
                  example: 张三  2030年截至
                  type: string
                mortgageStatus:
                  description: 抵押状况 1-无抵押  2-有抵押
                  example: 2
                  type: integer
                mortgageInfo:
                  description: 抵押人及金额
                  example: 王五  金额200万
                  type: string
                hukouStatus:
                  description: 是否有户口  1-无户口  2-有户口
                  example: 2
                  type: integer
                hukouNum:
                  description: 户口人数
                  example: 3
                  type: integer
                relationship:
                  description: 申报人与权利人关系 1-本人  2-配偶  3-子女   4-兄弟姐妹  5-其他
                  example: '5'
                  type: string
                relationshipOther:
                  description: 申报人与权利人关系-其他关系
                  example: 朋友
                  type: string
                certificateFile:
                  description: 权证文件
                  example: url1,url2,url3
                  type: string
                registerFile:
                  description: 登记文件
                  example: url1,url2,url3
                  type: string
                ownerIdcardFile:
                  description: 产权人身份文件
                  example: url1,url2,url3
                  type: string
                requesterIdcardFile:
                  description: 申报人身份文件
                  example: url1,url2,url3
                  type: string
                hukouFile:
                  description: 户口登记人户口本文件
                  example: url1,url2,url3
                  type: string
                floorPrice:
                  description: 最低报价（万元）
                  example: 89.9
                  type: number
                ceilingPrice:
                  description: 最高报价（万元）
                  example: 108
                  type: number
              required:
                - declareTime
                - requesterPhoneNum
                - requesterName
                - address
                - ownerName
                - type
                - certificateNumber
                - size
                - certificateFile
                - registerFile
                - ownerIdcardFile
                - requesterIdcardFile
                - floorPrice
                - ceilingPrice
            examples: {}
      responses:
        '200':
          description: ''
          content:
            text/html:
              schema:
                type: object
                properties: {}
                x-apifox-orders: []
          headers: {}
          x-apifox-name: 成功
      security: []
      x-apifox-folder: 用户端(小程序)/需要登录认证的/房源收购申报
      x-apifox-status: released
      x-run-in-apifox: https://app.apifox.com/web/project/6478600/apis/api-407948668-run
components:
  schemas: {}
  securitySchemes: {}
servers:
  - url: http://beta.fujuhaofang.com
    description: 测试环境
  - url: https://alpha.huichenghuijia.com
    description: 正式环境
security: []

```