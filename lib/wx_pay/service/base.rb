module WxPay
  module Service
    class Base

      private

      def authorize(params, options={})
        ::WxPay::Service.invoke_unifiedorder(params, options)
      end

      def purchase(params, options={})
        ::WxPay::Service.invoke_micropay(params, options)
      end

      def find_order(params, options={})
        ::WxPay::Service.order_query(params, options)
      end

      def void(params, options={})
        ::WxPay::Service.invoke_reverse(params, options)
      end

      def close(params, options={})
        ::WxPay::Service.invoke_closeorder(params, options)
      end

      def refund(params, options={})
        ::WxPay::Service.invoke_refund(params, options)
      end

      def find_refund(params, options={})
        ::WxPay::Service.refund_query(params, options)
      end

      def download_bill(params, options={})
        ::WxPay::Service.download_bill(params, options)
      end
    end
  end
end
