# Chatroom message area — design

**Branch:** feature/new-chat-ui · **Date:** 2026-07-06

Third phase of the chatroom UI refactor (sidebar and details panel already done).
Implements the middle conversation column from the Figma "Message" frame and rewires
chatroom switching + real-time to a Turbo-native architecture.

## Goals

- Build the conversation pane (message bubbles + composer) from the Figma.
- Make selecting a chatroom swap both the conversation and the details panel.
- Replace the hand-rolled Action Cable / Stimulus append path with Turbo Streams.
- Restore the selection wiring the sidebar refactor removed.
- Refresh the "weird beige" surface into an on-brand sage-tinted neutral.

## Decisions (confirmed)

- **Switching:** Turbo Frames (render only the active chatroom).
- **Composer:** text-only. Omit the Figma mic/attachment icons (no fake affordances).
- **Date separators:** include. Group messages by calendar day with a centered date pill.
- **Surface color:** the one-off `#e8e7d8` beige is unified to the app's existing cream
  `#f3f2e7`, tokenized as `$surface` in `config/_colors.scss`, and applied project-wide
  (chatroom, details panel, eventshow). **Done** ahead of this phase.

## Architecture

### Selection (Turbo Frames)
- Wrap `.chatroom__content` + `.chatroom__details` in a single
  `turbo_frame_tag "conversation"` styled `display: contents` (flex layout unaffected).
- Add `GET /chatrooms/:id` (`chatrooms#show`) rendering that frame for one chatroom:
  the conversation pane (`_messages`) + the details panel (`_details`).
- Sidebar rows become `link_to chatroom_path(chatroom), data: { turbo_frame: "conversation" }`.
  One click swaps center + details together.
- `chatrooms#index` renders the frame for `@chatrooms.first` (default open), or an empty
  state when the user has no chatrooms.
- Active-row highlight: a small Stimulus controller toggles
  `chatroom__list-item--active` on click (the sidebar lives outside the frame).

### Real-time (Turbo Streams)
- Conversation pane subscribes with `turbo_stream_from @chatroom`.
- Message list container: `div id="messages_<chatroom_id>"`.
- `Message after_create_commit` → `broadcast_append_to chatroom, target: "messages_<id>",
  partial: "messages/message"`.
- `messages#create` simplifies to save + `head :no_content`; the composer posts over Turbo.
  Broadcast-only append (sender included) avoids double render.
- Retire the custom `ChatroomChannel` and the append logic in
  `chatroom_subscription_controller.js`.
- Keep a slim Stimulus controller (`conversation`) for the three things Turbo won't do:
  1. per-viewer bubble side — add `message--left/right` from `data-user-id` vs the current
     user id (broadcast HTML is identical for all viewers);
  2. autoscroll to the newest message;
  3. relative/day timestamps (moment) + the appear animation class on inserted nodes.

### Bubbles (Figma)
- Restyle `messages/_message` (BEM):
  - incoming: avatar + green sender name above the bubble, timestamp below, left-aligned;
  - own: bubble + timestamp, right-aligned, no avatar/name.
- Day separator: centered pill rendered between date groups (server-side on initial load;
  the Stimulus controller inserts one when a broadcast crosses a day boundary).

### Empty states
- No chatrooms → prompt in the list + center pane.
- Chatroom with no messages → "No messages yet — say hello."

## Color tokens

Surface unified to `$surface: #f3f2e7` (existing app cream). Bubbles derive from it:

| Token | Value | Use |
|-------|-------|-----|
| `$surface` | `#f3f2e7` | details panel background (done) |
| bubble-in | `#f3f2e7` / `$surface` | incoming message bubble |
| bubble-own | `#e4ecdd` (soft brand-green tint) | own message bubble, for contrast vs cream |
| divider | `rgba(58,23,0,0.12)` | hairlines |
| sender | `$primary-color` (`#132a13`) | incoming sender name (green) |

Text stays `#3a1700`. Bubble-own value is a starting point — retuned against screenshots.

## Files touched

- `config/routes.rb` — add `show` to chatrooms.
- `app/controllers/chatrooms_controller.rb` — `show`; empty-state ivar.
- `app/controllers/messages_controller.rb` — drop manual broadcast.
- `app/models/message.rb` — `after_create_commit` broadcast.
- `app/channels/chatroom_channel.rb` — remove (Turbo owns the stream).
- `app/javascript/controllers/chatroom_subscription_controller.js` — replace with slim `conversation_controller.js`.
- `app/views/chatrooms/index.html.slim` — Turbo frame + empty state.
- `app/views/chatrooms/show.html.slim` — new; renders the frame.
- `app/views/chatrooms/_sidebar.html.slim` — rows become frame links; active toggle.
- `app/views/chatrooms/_messages.html.slim` — turbo_stream_from, date grouping, composer.
- `app/views/messages/_message.html.slim` — Figma bubble markup.
- `app/assets/stylesheets/components/_chatroom.scss` + `components/chat/message.scss` — styles.
- `app/assets/stylesheets/config/_colors.scss`, `_eventshow.scss` — `$surface` token + beige swap (done).

## Out of scope / follow-ups

- Attachments / voice messages (not supported by the model).
- Read receipts, unread badges, pin (Figma shows them; no backend).
- Sidebar live "You:" prefix on own last message (nice-to-have).
