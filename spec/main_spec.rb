require 'open-uri'
require 'support/models/product'

describe 'canary test' do
  it 'it true' do
    expect(true).to be true
  end


  it 'request success' do
    expect(Product.count).to eq 0

    response = open('http://localhost:8080/').read

    expect(Product.count).to eq 1

    product = Product.first

    expect(response).to eq 'Hello, World'

    expect(product.code).to eq 'L1212'
    expect(product.price).to eq 1000
  end
end
