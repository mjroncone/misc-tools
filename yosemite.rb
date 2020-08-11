require('httparty')

BOOKING_YEAR = '2020'
BOOKING_MONTH = '08'
BOOKING_DAY = '17'
BOOKING_DATE = "#{BOOKING_YEAR}-#{BOOKING_MONTH}-#{BOOKING_DAY}"

RESERVATION_URL = "https://www.recreation.gov/api/ticket/availability/facility/300015/monthlyAvailabilitySummaryView?year=#{BOOKING_YEAR}&month=#{BOOKING_MONTH}&day=#{BOOKING_DAY}&inventoryBucket=FIT".freeze
BOOKING_URL = 'https://www.recreation.gov/ticket/facility/300015'

loop do
  http_response = HTTParty.get(RESERVATION_URL).body
  response = JSON.parse(http_response)
  tour_details = response.dig(
    'facility_availability_summary_view_by_local_date',
    BOOKING_DATE,
    'tour_availability_summary_view_by_tour_id',
    '3000'
  )
  puts("Booking details for #{BOOKING_DATE} - Reserved: #{tour_details['reserved_count']}, reservable: #{tour_details['reservable']}")

  if tour_details['reservable'] > 0
    puts "RESERVABLE! BOOK IT NOW!"
    system("open #{BOOKING_URL}")
  end

  sleep(10)
end
