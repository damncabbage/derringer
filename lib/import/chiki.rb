module Import
  class Chiki

    attr_accessor :connection, :source_db

    def initialize(connection, source_db)
      self.connection = connection
      self.source_db = source_db
    end

    def import!(year=Time.now.year)
      truncate! # Commits any open transaction; can't rollback.
      connection.transaction do
        connection.execute(orders_sql(year))
        connection.execute(tickets_sql)
        connection.execute(ticket_tables_sql)
      end
    end

    def truncate!
      %w(orders tickets ticket_types).each { |t| connection.execute("TRUNCATE `#{table}`") }
    end

    protected

      def orders_sql(year)
        ["
          INSERT INTO `orders` (
            `id`, `code`, `bpay_crn`, `status`,
            `email`, `full_name`, `phone`,
            `address`, `state`, `postcode`,
            `underage_tickets`, `tickets_count`,
            `fully_paid_at`, `received_ticket_at`,
            `created_at`, `updated_at`
          ) SELECT
            `id`, `cache_code_prefix`, `cache_bpay_crn`, IF(`cache_has_paid`, 'resolved', IF(`deleted`, 'cancelled', 'payment_pending')),
            `customer_email`, `customer_full_name`, `customer_phone`,
            `customer_address`, `customer_state`, `customer_postcode`,
            0, -- TODO: under-7-tickets
            0, -- TODO: tickets_count
            NULL, NULL,
            `create_time`, `update_time`
          FROM `#{source_db}`.`chiki_order`
          WHERE
            (create_time > ? AND create_time < ? )
        ", "#{year}-01-01", "#{year}-12-31"]
      end

      def tickets_sql
        "
          INSERT INTO `tickets` (
            `id`, `order_id`, `ticket_type_id`,
            `code`, `full_name`, `age`,
            `gender`, `postcode`,
            `created_at`, `updated_at`
          ) SELECT
            `id`, `order_id`, `ticket_type_id`,
            `cache_code`, `customer_full_name`, `customer_age`,
            `customer_gender`, `customer_postcode`,
            `create_time`, `update_time`
          FROM `#{source_db}`.`chiki_ticket`
          WHERE
            order_id IN (
              SELECT id FROM orders
            )
        "
      end

      def ticket_types_sql
        "
          INSERT INTO `ticket_types` (
            `id`, `title`, `price`, `public`
          ) SELECT
            `id`, `name`, `price`, 1
          FROM `#{source_db}`.`chiki_ticket_type`
          WHERE
            id IN (
              SELECT id FROM tickets
            )
        "
      end

  end
end

