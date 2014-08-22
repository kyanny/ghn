require 'spec_helper'

describe Ghn::Notification do
  subject { Ghn::Notification.new(notification) }

  describe '#to_url' do
    context 'issue' do
      subject { Ghn::Notification.new fixture('issue.json') }

      it { expect(subject.to_url).to eq 'https://github.com/username/reponame/issues/305' }
    end

    context 'issue comment' do
      subject { Ghn::Notification.new fixture('issue_with_comment.json') }

      it { expect(subject.to_url).to eq 'https://github.com/username/reponame/issues/305#issuecomment-53070200' }
    end

    context 'pull request' do
      subject { Ghn::Notification.new fixture('pull_request.json') }

      it { expect(subject.to_url).to eq 'https://github.com/username/reponame/pull/22' }
    end

    context 'pull request with comment' do
      subject { Ghn::Notification.new fixture('pull_request_with_comment.json') }

      it { expect(subject.to_url).to eq 'https://github.com/username/reponame/pull/22#issuecomment-16607215' }
    end

    context 'commit' do
      subject { Ghn::Notification.new fixture('commit.json') }

      it { expect(subject.to_url).to eq 'https://github.com/username/reponame/commit/6a4a135335acef4dfe15912d231429c07d4ad143' }
    end

    context 'commit with comment' do
      subject { Ghn::Notification.new fixture('commit_with_comment.json') }

      it { expect(subject.to_url).to eq 'https://github.com/username/reponame/commit/6a4a135335acef4dfe15912d231429c07d4ad143#issuecomment-7491006' }
    end
  end
end
