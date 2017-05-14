class MicropayTest < MiniTest::Test
  def test_download_bill
    MiniTest::Test.stub_gateway([:download_bill], [WxPay::Service::Micropay.new]) { |r|
      assert r.body.include?("SUCCESS")
    }
  end

  def test_other_methods
    MiniTest::Test.stub_gateway([
      :purchase,
      :find_order,
      :void,
      :refund,
      :find_refund
    ], [WxPay::Service::Micropay.new]) { |r|
      assert r.success?
    }
  end
end
