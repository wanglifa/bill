class Api::V1::ItemsController < ApplicationController
  def index
    # 根据 created_at 字段筛选，起始时间到结束时间 params[:created_after]..params[:created_before]
    items = Item.where({created_at: params[:created_after]..params[:created_before]})
      .page(params[:page])
    render json: { resources: items, pager: {
      page: params[:page],
      per_page: 10,
      count: Item.count
    } }
  end
  def create
    item = Item.new amount: params[:amount]
    if item.save
      render json: {resource: item}
    else 
      render json: {errors: item.errors}
    end
  end
end
