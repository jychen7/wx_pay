
class ServiceTest < MiniTest::Test

  def setup
    @params = {
      transaction_id: '1217752501201407033233368018'
    }

    @auth_json_response = {
      "access_token" => "ACCESS_TOKEN",
      "expires_in" => 7200,
      "refresh_token" => "REFRESH_TOKEN",
      "openid" => "OPENID",
      "scope" => "SCOPE",
      "unionid" => "o6_bmasdasdsad6_2sgVt7hMZOPfL"
    }
  end

  def test_generate_authorize_url
    redirect_uri = "http://localhost"
    state = SecureRandom.hex(16)

    output = WxPay::Service.generate_authorize_url(redirect_uri, state)
    expect = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxd930ea5d5a258f4f&redirect_uri=http%253A%252F%252Flocalhost&response_type=code&scope=snsapi_base&state=#{state}"
    assert expect == output
  end

  def test_authenticate
    stub_request(:get, /api.weixin.qq.com\/sns\/oauth2\/access_token/).to_return(body: @auth_json_response.to_json)

    output = WxPay::Service.authenticate("")
    assert output == @auth_json_response
  end

  def test_authenticate_from_weapp
    stub_request(:get, /api.weixin.qq.com\/sns\/jscode2session/).to_return(body: @auth_json_response.to_json)

    output = WxPay::Service.authenticate_from_weapp("")
    assert output == @auth_json_response
  end

  def test_generate_app_pay_req
    timestamp = "1494683549"
    nonceStr = "7b7340e497d143b694521e9f948f7bda"
    output = WxPay::Service.generate_app_pay_req({timestamp: timestamp, nonceStr: nonceStr})
    expect = {
      appid: "wxd930ea5d5a258f4f",
      partnerid: "1900000109",
      package: "Sign=WXPay",
      timestamp: "1494683549",
      nonceStr: "7b7340e497d143b694521e9f948f7bda",
      sign: "8E33653F49F6C009E51010E2093397D4"
    }
    assert output == expect
  end

  def test_generate_js_pay_req
    timestamp = "1494683549"
    nonceStr = "7b7340e497d143b694521e9f948f7bda"
    output = WxPay::Service.generate_js_pay_req({timeStamp: timestamp, nonceStr: nonceStr})
    expect = {
      appId: "wxd930ea5d5a258f4f",
      package: "prepay_id=",
      nonceStr: "7b7340e497d143b694521e9f948f7bda",
      signType: "MD5",
      timeStamp: "1494683549",
      paySign: "1AD0A4FA98E51CDC9C820B1F8711CB0E"
    }
    assert output == expect
  end

  def test_invoke_with_gateway_result
    MiniTest::Test.stub_gateway([
      :invoke_unifiedorder, :invoke_closeorder,
      :invoke_refund, :refund_query,
      :invoke_transfer, :gettransferinfo,
      :invoke_reverse, :invoke_micropay,
      :order_query, :settlement_query,
      :sendgroupredpack, :sendredpack
    ], [WxPay::Service]) { |r|
      assert r.success?
    }
  end

  def test_request_gateway_raw_only
    MiniTest::Test.stub_gateway([
      :download_bill
    ], [WxPay::Service]) { |r|
      assert r.body.include?("SUCCESS")
    }
  end

  def test_accept_multiple_app_id_when_invoke
    params = {
      body: '测试商品',
      out_trade_no: 'test003',
      total_fee: 1,
      spbill_create_ip: '127.0.0.1',
      notify_url: 'http://making.dev/notify',
      trade_type: 'JSAPI',
      openid: 'OPENID',
      app_id: 'app_id',
      mch_id: 'mch_id',
      key: 'key'
    }
    xml_str = '<xml><body>测试商品</body><out_trade_no>test003</out_trade_no><total_fee>1</total_fee><spbill_create_ip>127.0.0.1</spbill_create_ip><notify_url>http://making.dev/notify</notify_url><trade_type>JSAPI</trade_type><openid>OPENID</openid><app_id>app_id</app_id><mch_id>mch_id</mch_id><sign>172A2D487A37D13FDE32B874BA823DD6</sign></xml>'
    assert_equal xml_str, WxPay::Service.send(:generate_signed_payload, params)
  end
end
