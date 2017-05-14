module WxPay
  module Service
    class Native < Base
      def authorize(params, options={})
        params[:trade_type] = "NATIVE"
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
