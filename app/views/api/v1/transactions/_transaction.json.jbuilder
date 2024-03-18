json.extract! transaction, :id, :kind, :receiver_type, :receiver_id,
              :giver_type, :giver_id, :amount, :created_at, :updated_at
json.url api_v1_transaction_url(transaction)
