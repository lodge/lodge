class Tasks::FixCount
  def self.execute
    Comment.counter_culture_fix_counts
  end
end
