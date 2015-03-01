module A
  def self.included(base)
    def base.inherited(child)
      puts "#{child.name} < #{name}"
    end
  end
end

class B
  include A
end

class C < B
end