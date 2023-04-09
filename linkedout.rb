# frozen_string_literal: true

require 'capybara/cuprite'
require 'capybara/dsl'
require 'io/console'

module LinkedOut
  module_function

  extend Capybara::DSL

  def config_capybara
    Capybara.register_driver(:cuprite) do |app|
      Capybara::Cuprite::Driver.new(app, {
                                      headless: false,
                                      browser_options: {
                                        'disable-blink-features' => 'AutomationControlled'
                                      }
                                    })
    end

    Capybara.configure do |c|
      c.default_driver = :cuprite
      # do not try to start a rack app
      c.run_server = false
      # some inputs are not identified by <label> elements, only aria attributes
      c.enable_aria_label = true
    end
  end

  def ask_for_credentials
    puts 'Please provide your credentials'
    print 'Email: '
    email = gets.chomp

    print 'Password: '
    password = $stdin.noecho(&:gets)
    puts

    [email, password]
  end

  def ask_for_mfa
    print 'Enter 2FA code: '
    mfa_code = $stdin.noecho(&:gets)
    puts

    mfa_code
  end

  def mfa_push?
    page.has_content?('Open your LinkedIn app and tap Yes to confirm your sign-in')
  end

  def mfa_auth_app?
    page.has_content?('Enter the code you see on your authenticator app')
  end

  def sign_in
    email, password = ask_for_credentials

    visit 'https://www.linkedin.com/login/'

    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_button 'Sign in'

    if mfa_push?
      puts 'Tap "Yes" on the app to confirm the sign-in attempt'
    elsif mfa_auth_app?
      mfa_code = ask_for_mfa

      fill_in 'Please enter the code here', with: mfa_code
      click_button 'Submit'
    end

    until page.has_button?('Start a post')
      puts 'Waiting...'
      sleep 1
    end
  end

  def rand_sleep
    # wait for a while to avoid being blocked for making too many requests
    # choosing a random number between 1 and 3 seconds
    secs = rand(1.0..3.0).round(2)
    sleep(secs)
  end

  def unfollow(card)
    name = card.find('.follows-recommendation-card__name').text
    print "Unfollowing #{name.inspect}... "

    if card.has_button?('Follow', exact: true)
      # sometimes the card appears again with a button to follow the
      # person/company that you just unfollowed
      puts '✔️ Already unfollowed'
    else
      card.click_button('Following')
      puts '✔️ Unfollowed'

      rand_sleep
    end
  end

  def unfollow_everyone!
    config_capybara
    sign_in

    visit 'https://www.linkedin.com/feed/following/'

    loop do
      if page.has_text?('Looks like you aren’t following anyone yet.')
        puts 'Done! You just unfollowed everyone!!! 🥳 ✌️'
        break
      end

      within('.feed-following-list') do
        all('.follows-recommendation-card').each do |card|
          unfollow(card)
        end

        page.refresh
      end
    end
  end
end

LinkedOut.unfollow_everyone!
