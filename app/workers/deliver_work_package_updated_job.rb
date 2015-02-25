#-- encoding: UTF-8
#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2015 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

class DeliverWorkPackageUpdatedJob
  def initialize(user_id, journal_id, current_user_id)
    @user_id         = user_id
    @journal_id      = journal_id
    @current_user_id = current_user_id
  end

  def perform
    notification_mail.deliver
  end

  def error(_job, e)
    Rails.logger.error "notification of #{user.mail} failed (work package updated): #{e}"
  end

  private

  def notification_mail
    @notification_mail ||= UserMailer.work_package_updated(user, journal, current_user)
  end

  def user
    @user ||= Principal.find(@user_id)
  end

  def journal
    @journal ||= Journal.find(@journal_id)
  end

  def current_user
    @current_user ||= Principal.find(@current_user_id)
  end
end
