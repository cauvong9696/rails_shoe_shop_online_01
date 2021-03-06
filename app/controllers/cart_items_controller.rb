class CartItemsController < ApplicationController
  before_action :logged_in_user, only: :create

  def create
    @notice = t "add_success"
    @cart = Cart.find_or_create_by user: current_user
    @shoe = Shoe.find_by id: params[:shoe][:shoe_id]
    cart_item = @cart.cart_items.find_by shoe: @shoe

    if params[:shoe][:quantity].to_i <= @shoe.quantity
      create_cart_item cart_item
      @shoe.update quantity: @shoe.quantity - params[:shoe][:quantity].to_i
    else
      @notice = t "out_of_stock"
    end
    respond_to do |format|
      format.js
    end
  end

  def update
    cart_item = CartItem.find_by id: params[:id]
    @shoe = cart_item.shoe
    count = cart_item.quantity

    if params[:cart_item][:quantity].to_i <= @shoe.quantity + count
      cart_item.update quantity: params[:cart_item][:quantity].to_i
      @shoe.update quantity:
        @shoe.quantity + count - params[:cart_item][:quantity].to_i
    end

    price_item = ApplicationController.helpers.number_to_currency(
      cart_item.total_price
    )
    total_price_cart = ApplicationController.helpers.number_to_currency(
      cart_item.cart.total_price
    )
    render json: {status: :success, price: price_item, total_price: total_price_cart}
    
  end

  def destroy
    @notice = t "delete_success"
    cart_item = CartItem.find_by id: params[:id]
    @cart_item_id = cart_item.id
    cart_item.destroy
    shoe = cart_item.shoe
    shoe.update quantity: shoe.quantity + cart_item.quantity
    respond_to do |format|
      format.js
    end
  end

  private

  def create_cart_item cart_item
    if cart_item
      cart_item.update quantity:
        cart_item.quantity + params[:shoe][:quantity].to_i
    else
      CartItem.create quantity:
        params[:shoe][:quantity], cart: @cart, shoe: @shoe
    end
  end
end
