module PartnershipDeed
  class PartnershipDeedPdf < ApplicationPdf
    def initialize(startup)
      @startup = startup.decorate
      super()
    end

    def build(combinable: false)
      add_title
      declare_partners
      add_whereas_clause
      add_agreement_clauses
      add_signatures
      combinable ? CombinePDF.parse(render) : self
    end

    private

    def add_title
      move_down 300
      text '<b><u>DEED OF PARTNERSHIP</u></b>', align: :center, inline_format: true, size: 15
    end

    def declare_partners
      move_down 10
      text t('partnership_deed.declaration.header', day: Date.today.day.ordinalize, month: Date.today.strftime('%B %Y')), inline_format: true
      add_partner_details
      text t('partnership_deed.declaration.footer')
    end

    def add_partner_details
      move_down 5
      founders.each_with_index { |founder, index| add_founder_to_partners(founder, index) }
    end

    def add_founder_to_partners(founder, index)
      @founder = founder.decorate
      @index = index
      text partner_description, inline_format: true, indent_paragraphs: 30
      move_down 5
    end

    def partner_description
      t(
        'partnership_deed.declaration.partner_description',
        index: @index + 1,
        ordinalized_index: ORDINALIZE[@index],
        name: @founder.name,
        son_or_daughter: @founder.son_or_daughter,
        parent_name: @founder.parent_name,
        age: @founder.age,
        current_address: @founder.communication_address.squish,
        id_proof_type: @founder.id_proof_type,
        id_proof_number: @founder.id_proof_number
      )
    end

    def add_whereas_clause
      move_down 10
      text '<b>WHEREAS:</b>', inline_format: true
      move_down 5
      text t('partnership_deed.whereas_cluases'), inline_format: true
    end

    # rubocop: disable Metrics/AbcSize, Metrics/MethodLength
    def add_agreement_clauses
      move_down 10
      text t('partnership_deed.agreements_header'), inline_format: true

      # Section 1: Definitions
      move_down 10
      font 'Times-Roman', style: :normal
      text t('partnership_deed.s1.part_1'), inline_format: true
      move_down 15
      stroke_horizontal_rule
      move_down 10
      text t('partnership_deed.s1.part_2')

      # Section 2: Commencement of the Partnership Business
      move_down 10
      text t('partnership_deed.s2'), inline_format: true

      # Section 3: Name and Address of the Firm
      move_down 10
      text t('partnership_deed.s3.heading'), inline_format: true
      text t('partnership_deed.s3.part_1')
      move_down 15
      stroke_horizontal_rule
      move_down 10
      text t('partnership_deed.s3.part_2', team_lead_address: @startup.admin.communication_address.squish), inline_format: true

      # Section 4: Partnership Business
      move_down 10
      text t('partnership_deed.s4'), inline_format: true

      # Section 5: Partners
      move_down 10
      text t('partnership_deed.s5.part_1'), inline_format: true
      text t('partnership_deed.s5.part_2'), indent_paragraphs: 30
      text t('partnership_deed.s5.part_3'), indent_paragraphs: 60
      text t('partnership_deed.s5.part_4_heading')
      text t('partnership_deed.s5.part_4'), indent_paragraphs: 30

      # Section 6: Capital Contribution
      move_down 10
      text t('partnership_deed.s6.heading'), inline_format: true
      move_down 10
      text t('partnership_deed.s6.c1', capital: founders_count * 1000, capital_in_words: "#{HUMANIZE[founders_count - 1]} Thousand")
      add_capital_contribution_table
      move_down 10
      text t('partnership_deed.s6.c2_to_6')

      # Section 7: Sharing of Profits and Losses
      move_down 10
      text t('partnership_deed.s7.heading'), inline_format: true
      move_down 10
      text t('partnership_deed.s7.c1'), inline_format: true
      add_profit_sharing_table
      move_down 10
      text t('partnership_deed.s7.c2_to_3'), inline_format: true

      # Section 8: Financial year and accounts
      move_down 10
      text t('partnership_deed.s8'), inline_format: true

      # Section 9: Bank Account
      move_down 10
      text t('partnership_deed.s9'), inline_format: true

      # Section 10: Records and Books
      move_down 10
      text t('partnership_deed.s10'), inline_format: true

      # Section 11: Borrowing Powers
      move_down 10
      text t('partnership_deed.s11'), inline_format: true

      # Section 12: Covenants of the Partners
      move_down 10
      text t('partnership_deed.s12.heading'), inline_format: true
      text t('partnership_deed.s12.c1.heading')
      text t('partnership_deed.s12.c1.clauses'), indent_paragraphs: 30
      text t('partnership_deed.s12.c2.heading')
      text t('partnership_deed.s12.c2.clauses'), indent_paragraphs: 30

      # Section 13: Term
      move_down 10
      text t('partnership_deed.s13.part_1'), inline_format: true
      text t('partnership_deed.s13.part_2'), indent_paragraphs: 30

      # Section 14: Retirement or Death
      move_down 10
      text t('partnership_deed.s14.part_1'), inline_format: true
      text t('partnership_deed.s14.part_2'), indent_paragraphs: 30
      text t('partnership_deed.s14.part_3')
      text t('partnership_deed.s14.part_4'), indent_paragraphs: 30

      # Section 15: Miscellaneous
      move_down 10
      text t('partnership_deed.s15'), inline_format: true
    end

    # rubocop: enable Metrics/AbcSize, Metrics/MethodLength

    def add_capital_contribution_table
      move_down 10
      table_rows = [['<b>Partner</b>', '<b>Amount</b>']]
      founders.each_with_index do |_founder, index|
        table_rows << ["#{ORDINALIZE[index]} Partner", 'Rs. 1000']
      end

      table table_rows, position: :center, width: 300, cell_style: { inline_format: true }
    end

    def add_profit_sharing_table
      move_down 10
      share_per_founder = format('%g', format('%.2f', (100.to_f / founders_count)))
      table_rows = [['<b>Partner</b>', '<b>Sharing Ratio (in percentage)</b>']]
      founders.each_with_index do |_founder, index|
        table_rows << ["#{ORDINALIZE[index]} Partner", "#{share_per_founder}%"]
      end

      table table_rows, position: :center, width: 300, cell_style: { inline_format: true }
    end

    def add_signatures
      move_down 10
      text t('partnership_deed.signatures.header')
      founders.each_with_index { |founder, index| add_signature_section(founder, index) }
    end

    def add_signature_section(founder, index)
      move_down 15
      text 'Signed and delivered by'
      move_down 10
      text '____________________________________'
      text founder.name
      text "(The #{ORDINALIZE[index]} Partner)"
    end

    ORDINALIZE = %w[First Second Third Fourth Fifth Sixth Seventh Eighth Ninth Tenth].freeze
    HUMANIZE = %w[One Two Three Four Five Six Seven Eight Nine Ten].freeze

    def founders_count
      @founders_count ||= founders.count
    end

    def founders
      @founders ||= @startup.founders.to_a
    end
  end
end
