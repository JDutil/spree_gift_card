module Spree
  module Admin
    class GiftCardsController < Spree::Admin::ResourceController

      def index
        @batch_id = params[:batch_id]

        if @batch_id
          gift_cards = GiftCard.where(:batch_id => @batch_id)
          @batch_quantity = gift_cards.count
          @batch_amount = gift_cards.first.original_value
        else
          gift_cards = GiftCard
        end
        @gift_cards = gift_cards.page(params[:page]).per(50)
      end

      # GET /show
      # GET /show.csv
      def show
        @batch_id = params[:batch_id]

        @gift_card = GiftCard.find(params[:id])
        if @batch_id
          @gift_cards = GiftCard.where(:batch_id => @batch_id)
        else
          @gift_cards = [@gift_card]
        end

        respond_to do |format|
          format.html
          format.csv
        end
      end

      def create
        if params.has_key?(:generate) && params[:generate]["quantity"].to_i > 1
          create_many
        else
          if @gift_card.save
            flash.notice = I18n.t(:successfully_created_gift_card)
            redirect_to admin_gift_cards_path
          else
            find_gift_card_variants
            render :new
          end
        end
      end

      def edit
        find_gift_card_variants
      end

      def new
        find_gift_card_variants
      end

      private

      def find_gift_card_variants
        gift_card_product_ids = Product.not_deleted.where(["is_gift_card = ?", true]).map(&:id)
        @gift_card_variants = Variant.where(["price > 0 AND product_id IN (?)", gift_card_product_ids]).order("price")
      end

      def create_many
        quantity = params[:generate]["quantity"].to_i

        if quantity == 1
          create
        else
          batch_id = get_next_batch_id
          codes = generate_batch_of_unique_codes(quantity)

          for i in 1..quantity
            card = Spree::GiftCard.new(params[:gift_card])
            card.code = codes[i]
            card.batch_id = batch_id
            card.skip_unique_code = true
            if !card.save
              @gift_card = card
              find_gift_card_variants
              render :new
              break
            end
          end
          flash.notice = I18n.t(:multiple_successfully_created_gift_cards, :quantity => quantity)
          redirect_to admin_gift_cards_path :batch_id => batch_id
        end
      end

      def generate_batch_of_unique_codes(quantity=1)
        unique_codes = []

        begin
          # generate a batch of codes
          raw_codes = []
          needed = quantity - unique_codes.length
          for i in 1..needed
            raw_codes << Spree::GiftCard::generate_raw_code
          end

          # check against the database
          Spree::GiftCard.where(code: raw_codes).find_each do |card|
            # remove any collisions
            raw_codes.delete[card.code]
          end

          # save the good ones
          unique_codes |= raw_codes
        end until unique_codes.length >= quantity

        return unique_codes
      end

      # Used so we can keep track of batches we produce
      # (We may want to add a GiftCardBatch model in the future if we want to do more with batches.
      # Using batch_id may make this easier in to implement down the road)
      def get_next_batch_id
        (GiftCard.where("batch_id > 0").order("batch_id DESC").limit(1).pluck(:batch_id)[0] || 0) + 1
      end

    end
  end
end
