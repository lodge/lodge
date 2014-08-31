class CommentNotification < Notification
  def localize_key
    "comment_#{state}"
  end
end
