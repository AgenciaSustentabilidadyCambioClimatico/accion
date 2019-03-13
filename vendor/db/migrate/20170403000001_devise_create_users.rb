class DeviseCreateUsers < ActiveRecord::Migration[5.1]
	def change
		PostgresHelper.with_schema('public') do
			create_table :users do |t|
				## Database authenticatable
				t.string		:rut, null: false
				# t.string		:nombres, null: false
				# t.string		:apellido_paterno, null: false
				# t.string		:apellido_materno, null: false
				t.string		:nombre_completo, null: false
				t.string		:telefono, null: false
				t.string		:email,  null: false, default: ""
				t.string		:web_o_red_social_1
				t.string		:web_o_red_social_2
				t.text			:fields_visibility
				t.text			:session
				t.string		:encrypted_password, null: false, default: ""

				## Recoverable
				t.string		:reset_password_token
				t.datetime	:reset_password_sent_at

				## Rememberable
				t.datetime	:remember_created_at

				## Trackable
				t.integer		:sign_in_count, default: 0, null: false
				t.datetime	:current_sign_in_at
				t.datetime	:last_sign_in_at
				t.inet			:current_sign_in_ip
				t.inet			:last_sign_in_ip

				## Confirmable
				t.string		:confirmation_token
				t.datetime	:confirmed_at
				t.datetime	:confirmation_sent_at
				t.string		:unconfirmed_email # Only if using reconfirmable

				## Lockable
				t.integer 	:failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
				t.string		:unlock_token # Only if unlock strategy is :email or :both
				t.datetime	:locked_at


				t.timestamps null: false
			end
		end
		add_index :users, :email,									unique: true
		add_index :users, :reset_password_token,	unique: true
		add_index :users, :confirmation_token,		unique: true
		add_index :users, :unlock_token,					unique: true
		add_index :users, :rut,										unique: true
	end
end