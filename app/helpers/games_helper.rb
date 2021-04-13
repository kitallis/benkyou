module GamesHelper
  def points(play)
    if @game.stopped?
      play.score
    else
      "TBA"
    end
  end

  def status(play)
    play.status
  end

  def trophy(play)
    return unless play.in?(@game.winners)
    tag.span(class: "icon") { tag.i class: "fas fa-trophy" }
  end
end
