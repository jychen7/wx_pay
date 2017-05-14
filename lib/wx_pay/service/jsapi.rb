module WxPay
  module Service
    class Jsapi < Base
      def authorize(params, options={})
        params[:trade_type] = "JSAPI"
        super(params, options)
      end

      public :find_order
      public :close
      public :refund
      public :find_refund
      public :download_bill
    end
  end
end
