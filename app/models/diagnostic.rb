# -*- encoding : utf-8 -*-
class Diagnostic < ActiveRecord::Base
  attr_accessible :acronime, :description
  has_many :consul_diags
  validates  :description, :presence => true
  validates  :description, :uniqueness => true
  
end
