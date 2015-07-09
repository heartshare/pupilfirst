class MentorSkill < ActiveRecord::Base
  EXPERTISE_INTERMEDIATE = 'intermediate'
  EXPERTISE_ADVANCED = 'advanced'
  EXPERTISE_EXPERT = 'expert'

  def self.valid_expertise_values
    [EXPERTISE_INTERMEDIATE, EXPERTISE_ADVANCED, EXPERTISE_EXPERT]
  end

  belongs_to :mentor
  belongs_to :skill, class_name: 'Category'

  validates_presence_of :mentor
  validates_presence_of :skill
  validates_inclusion_of :expertise, in: valid_expertise_values, allow_nil: true
  validates_uniqueness_of :mentor_id, scope: :skill_id

  normalize_attribute :expertise
end
