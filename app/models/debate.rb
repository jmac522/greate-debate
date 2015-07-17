class Debate < ActiveRecord::Base
  belongs_to :topic
  has_many :debate_sides
  has_many :sides, through: :debate_sides
  has_many :debate_participants
  has_many :users, through: :debate_participants
  has_many :arguments

  def side_1
    sides.first
  end

  def side_2
    sides.second
  end

  def player_1
    DebateParticipant.find_by(debate: self, side: self.side_1).user
  end

  def player_2
    DebateParticipant.find_by(debate: self, side: self.side_2).user
  end

  def participant?(current_user)
    users.include?(current_user)
  end


  def taken_side
    debate_participants.first.side
  end

  def remaining_side
    if side_1 == taken_side
      side_2
    else
      side_1
    end
  end

  def is_turn?(current_user)
    self.turn == DebateParticipant.find_by(user:current_user, debate: self).side.title
  end

  def swap_turn
    if self.turn == side_1.title
      self.turn = side_2.title
      save
    else
      self.turn = side_1.title
      save
    end
  end

  def empty?
    debate_participants.count == 0
  end

  def open?
    debate_participants.count == 1
  end
end
