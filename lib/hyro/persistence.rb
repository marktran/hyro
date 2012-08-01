module Hyro
  module Persistence
    
    def persisted?
      !!@is_persisted
    end
    
    def save
      save!
      true
    rescue Hyro::Error
      false
    end
    
    def save!
      resp = if persisted?
        connection.put( "#{configuration.base_path}/#{id}", attributes )
      else
        connection.post( "#{configuration.base_path}", attributes )
      end
      
      load_attributes(resp.body[configuration.root_name])
      
      @is_persisted = true
      @previously_changed = changes
      @changed_attributes.clear
      
      self
    end
    
  end
end