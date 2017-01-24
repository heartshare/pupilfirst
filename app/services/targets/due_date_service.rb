module Targets
  class DueDateService
    def initialize(batch)
      @batch = batch
    end

    def expired?(target)
      prepare_if_required
      due_date(target) < Time.now
    end

    def expiring?(target)
      prepare_if_required
      due_date(target).between?(Date.today, 8.days.from_now)
    end

    def prepare
      # Eagerly load all required data for calculating due dates
      targets = Target.includes(target_group: { program_week: :batch }).where(program_weeks: { batch_id: @batch.id })

      @due_dates_hash = targets.each_with_object({}) do |target, hash|
        hash[target.id] = target.due_date.end_of_day
      end
    end

    def due_date(target)
      @due_dates_hash[target.id]
    end

    private

    def prepare_if_required
      prepare unless instance_variable_defined?(:@due_dates_hash)
    end
  end
end
