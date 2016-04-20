module BelongsToTubityLink

  def self.included(klass)
    klass.class_eval do

      include InstanceMethods
    end
  end

  module InstanceMethods

    # readonly property, you can set ID only on creation
    def tubity_link
      TubityLink[self.tubity_link_id]
    end
  end


end