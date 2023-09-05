require 'rails_helper'

RSpec.describe VideosChannel, type: :channel do
  it 'successfully subscribes' do
    subscribe
    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from('VideosChannel')
  end
end
