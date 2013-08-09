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
        connection.execute(ticket_types_sql)
        #connection.execute(update_counts_sql)
      end
    end

    def truncate!
      %w(orders tickets ticket_types).each { |table| connection.execute("TRUNCATE `#{table}`") }
    end

    protected

      def orders_sql(year)
        "
          INSERT INTO `orders` (
            `id`, `code`, `bpay_crn`, `status`,
            `email`, `full_name`, `phone`,
            `address`, `state`, `postcode`,
            `tickets_count`,
            `fully_paid_at`, `received_ticket_at`,
            `created_at`, `updated_at`
          ) SELECT
            `id`, `cache_code_prefix`, `cache_bpay_crn`, IF(`cache_has_paid`, 'resolved', IF(`deleted`, 'cancelled', 'payment_pending')),
            `customer_email`, `customer_full_name`, `customer_phone`,
            `customer_address`, `customer_state`, `customer_postcode`,
            `cache_tickets_count`, -- TODO: tickets_count
            NULL, NULL,
            `create_time`, `update_time`
          FROM `#{source_db}`.`chiki_order`
          WHERE
            (create_time > '#{year.to_i}-01-01' AND create_time < '#{year.to_i}-12-31')
        "
      end

      def tickets_sql
        "
          INSERT INTO `tickets` (
            `id`, `order_id`, `ticket_type_id`,
            `code`, `full_name`,
            `created_at`, `updated_at`
          ) SELECT
            `id`, `order_id`, `ticket_type_id`,
            `cache_code`, `customer_full_name`,
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
              SELECT ticket_type_id FROM tickets
            )
        "
      end

      def update_counts_sql

      end

  end
end

