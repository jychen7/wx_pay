class AppNativeJsTest < MiniTest::Test
  def test_download_bill
    MiniTest::Test.stub_gateway(
      [:download_bill],
      [WxPay::Service::Jsapi.new,
       WxPay::Service::Native.new,
       WxPay::Service::App.new
      ]) { |r|
      assert r.body.include?("SUCCESS")
    }
  end

  def test_other_methods
    MiniTest::Test.stub_gateway(
      [:authorize,
       :find_order,
       :close,
       :refund,
       :find_refund
      ],
      [WxPay::Service::Jsapi.new,
       WxPay::Service::Native.new,
       WxPay::Service::App.new
      ]) { |r|
      assert r.success?
    }
  end
end
