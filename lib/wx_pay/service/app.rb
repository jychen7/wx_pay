module WxPay
  module Service
    class App < Base
      def authorize(params, options={})
        params[:trade_type] = "APP"
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
