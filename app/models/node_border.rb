# frozen_string_literal: true

class NodeBorder < ApplicationRecord
  store_accessor :position, :position_x
  store_accessor :position, :position_y

  belongs_to :node

  enum direction: {
    top: 0,
    right: 1,
    bottom: 2,
    left: 3
  }

  enum color: {
    black: 0,
    gray: 1
  }
end
