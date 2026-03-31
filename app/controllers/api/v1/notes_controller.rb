module Api
  module V1
    class NotesController < ApplicationController
      before_action :authenticate_user!, only: [:index, :show]

      def index 
        paginated_notes = notes.page(params[:page]).per(params[:page_size])
        render json: paginated_notes, status: :ok, each_serializer: IndexNoteSerializer
      end

      def show
        render json: note, status: :ok, serializer: ShowNoteSerializer
      end

      def create
      end

      private

      def notes
        @notes = Note.includes(:utility)
        @notes = @notes.where(note_type: params[:type]) if params[:type].present?
        @notes = @notes.order(created_at: params[:order].presence || :desc)
      end

      def note
        @note ||= Note.find(params[:id])
      end

    end
  end
end
