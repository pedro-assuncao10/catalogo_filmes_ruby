threads_count = Integer(ENV.fetch("RAILS_MAX_THREADS", 3))
threads threads_count, threads_count

port ENV.fetch("PORT", 3000)

environment ENV.fetch("RACK_ENV") { ENV.fetch("RAILS_ENV", "production") }

workers Integer(ENV.fetch("WEB_CONCURRENCY", 2))

preload_app!

plugin :tmp_restart
plugin :solid_queue if ENV["SOLID_QUEUE_IN_PUMA"]

pidfile ENV["PIDFILE"] if ENV["PIDFILE"]

on_worker_boot do
ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end