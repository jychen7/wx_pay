module WxPay
  module Service
    class Micropay < Base
      public :purchase
      public :find_order
      public :void
      public :refund
      public :find_refund
      public :download_bill
    end
  end
end
