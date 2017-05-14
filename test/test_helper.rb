require 'coveralls'
Coveralls.wear!

require 'active_support/core_ext/hash/conversions'
require 'minitest/autorun'
require 'wx_pay'
require 'webmock/minitest'

WxPay.appid = 'wxd930ea5d5a258f4f'
WxPay.key = '8934e7d15453e97507ef794cf7b0519d'
WxPay.mch_id = '1900000109'
WxPay.debug_mode = true

WxPay.apiclient_key = File.read("#{__dir__}/fixtures/files/alice.key")
WxPay.apiclient_cert = File.read("#{__dir__}/fixtures/files/alice.crt")
WxPay.set_apiclient_by_pkcs12(File.read("#{__dir__}/fixtures/files/alice.pfx"), "pass")

class MiniTest::Test
  def self.stub_gateway(methods, objects)
    response_body = <<-EOF
     <xml>
       <return_code><![CDATA[SUCCESS]]></return_code>
       <result_code><![CDATA[SUCCESS]]></result_code>
     </xml>
    EOF
    WebMock::API.stub_request(:any, /api.mch.weixin.qq.com/).to_return(body: response_body)

    methods.each do |public_method|
      objects.each do |object|
        r = object.public_send(public_method, {})
        yield(r)
      end
    end
  end
end
