module Mocha
  module Integration
    module TestUnit
      module GemVersion200
        def self.applicable_to?(test_unit_version, ruby_version = nil)
          Gem::Requirement.new('2.0.0').satisfied_by?(test_unit_version)
        end

        def self.description
          "monkey patch for Test::Unit gem v2.0.0"
        end

        def self.included(mod)
          MonkeyPatcher.apply(mod, RunMethodPatch)
        end

        module RunMethodPatch
          def run(result)
            assertion_counter = AssertionCounter.new(self)
            begin
              @_result = result
              yield(Test::Unit::TestCase::STARTED, name)
              begin
                begin
                  run_setup
                  __send__(@method_name)
                  mocha_verify(assertion_counter)
                rescue Mocha::ExpectationError => e
                  add_failure(e.message, e.backtrace)
                rescue Exception
                  @interrupted = true
                  raise unless handle_exception($!)
                ensure
                  begin
                    run_teardown
                  rescue Mocha::ExpectationError => e
                    add_failure(e.message, e.backtrace)
                  rescue Exception
                    raise unless handle_exception($!)
                  end
                end
              ensure
                mocha_teardown
              end
              result.add_run
              yield(Test::Unit::TestCase::FINISHED, name)
            ensure
              @_result = nil
            end
          end
        end
      end
    end
  end
end
