class TestController < ApplicationController
  def hello
    render json: {test: 'hello world'}
  end
end 