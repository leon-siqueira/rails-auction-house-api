# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StartAuctionJob, type: :job do
  include ActiveJob::TestHelper
  subject(:start_auction) { described_class.perform_now(auction) }

  describe '#perform' do
    let(:auction) { create(:auction, status: :scheduled, start_date: 1.second.from_now) }

    it 'starts the auction' do
      expect { start_auction }.to change(auction, :status).from('scheduled').to('in_progress').and enqueue_job(EndAuctionJob)
    end
  end
end
