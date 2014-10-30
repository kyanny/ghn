require 'spec_helper'

describe Ghn::Notification do
  describe '#type_class' do
    let(:follow_issuecomment) { false }

    subject { Ghn::Notification.new(notification, follow_issuecomment).type_class }

    context 'issue' do
      let(:notification) { fixture('issue.json') }

      it { is_expected.to eq Ghn::IssueNotification }
    end

    context 'pull request' do
      let(:notification) { fixture('pull_request.json') }

      it { is_expected.to eq Ghn::PullRequestNotification }
    end

    context 'commit' do
      let(:notification) { fixture('commit.json') }

      it { is_expected.to eq Ghn::CommitNotification }
    end

    context 'release' do
      let(:notification) { fixture('release.json') }

      it { is_expected.to eq Ghn::ReleaseNotification }
    end

    context 'unknown' do
      let(:notification) { fixture('unknown.json') }

      it { is_expected.to eq Ghn::UnknownNotification }
    end
  end

  describe Ghn::IssueNotification do
    describe '#url' do
      it do
        expect(
          Ghn::IssueNotification.new(fixture('issue.json'), false).url
        ).to eq 'https://github.com/username/reponame/issues/305'
      end

      context 'with comment and --follow-issuecomment is turned on' do
        it do
          expect(
            Ghn::IssueNotification.new(fixture('issue_with_comment.json'), true).url
          ).to eq 'https://github.com/username/reponame/issues/305#issuecomment-53070200'
        end
      end

      context 'with comment but --follow-issuecomment is turned off' do
        it do
          expect(
            Ghn::IssueNotification.new(fixture('issue_with_comment.json'), false).url
          ).to eq 'https://github.com/username/reponame/issues/305'
        end
      end
    end
  end

  describe Ghn::PullRequestNotification do
    describe '#url' do
      it do
        expect(
          Ghn::PullRequestNotification.new(fixture('pull_request.json'), false).url
        ).to eq 'https://github.com/username/reponame/pull/22'
      end

      context 'with comment and --follow-issuecomment is turned on' do
        it do
          expect(
            Ghn::PullRequestNotification.new(fixture('pull_request_with_comment.json'), true).url
          ).to eq 'https://github.com/username/reponame/pull/22#issuecomment-16607215'
        end
      end

      context 'with comment but --follow-issuecomment is turned off' do
        it do
          expect(
            Ghn::PullRequestNotification.new(fixture('pull_request_with_comment.json'), false).url
          ).to eq 'https://github.com/username/reponame/pull/22'
        end
      end
    end
  end

  describe Ghn::CommitNotification do
    describe '#url' do
      it do
        expect(
          Ghn::CommitNotification.new(fixture('commit.json'), false).url
        ).to eq 'https://github.com/username/reponame/commit/6a4a135335acef4dfe15912d231429c07d4ad143'
      end

      context 'with comment and --follow-issuecomment is turned on' do
        it do
          expect(
            Ghn::CommitNotification.new(fixture('commit_with_comment.json'), true).url
          ).to eq 'https://github.com/username/reponame/commit/6a4a135335acef4dfe15912d231429c07d4ad143#issuecomment-7491006'
        end
      end

      context 'with comment but --follow-issuecomment is turned off' do
        it do
          expect(
            Ghn::CommitNotification.new(fixture('commit_with_comment.json'), false).url
          ).to eq 'https://github.com/username/reponame/commit/6a4a135335acef4dfe15912d231429c07d4ad143'
        end
      end
    end
  end

  describe Ghn::ReleaseNotification do
    describe '#url' do
      before do
        allow(Net::HTTP).
          to receive(:get).and_return '{"html_url":"https://github.com/yandod/candycane/releases/tag/v2.1.0"}'
      end

      it do
        expect(
          Ghn::ReleaseNotification.new(fixture('release.json'), false).url
        ).to eq 'https://github.com/yandod/candycane/releases/tag/v2.1.0'
      end
    end
  end

  describe Ghn::UnknownNotification do
    describe '#url' do
      it do
        expect(
          Ghn::UnknownNotification.new(fixture('release.json'), false).url
        ).to be nil
      end
    end
  end
end
