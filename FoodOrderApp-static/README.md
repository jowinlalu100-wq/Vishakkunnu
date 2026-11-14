# Vishakkunnu - Food Order App (static front end)

Front-end-only version of the Java/JSP project, ready for **GitHub Pages**.
The servlets and MySQL database are replaced by a small browser-side demo layer
(`assets/demo.js`), so every page and flow works without a server.

## Deploy on GitHub Pages
1. Create a new repository and upload everything in this folder (keep `index.html` at the top level).
2. Repo **Settings -> Pages -> Build and deployment -> Deploy from a branch**.
3. Choose branch `main` and folder `/ (root)`, then Save.
4. After a minute the site is live at `https://<your-username>.github.io/<repo-name>/`.

## What works
- Home, Book Now (menu, cart, date/time and table picker), checkout, receipt, Your Bookings
- Login / sign-up / admin portal: **any** email and password is accepted (demo only)
- Orders, users, contact messages and menu edits are saved in the visitor's own browser (localStorage)
- Admin dashboard: add / edit / delete dishes, view users, orders and messages

## Editing the menu
Dishes live in `DEFAULT_MENU` at the top of `assets/demo.js`. Add a photo by putting it in
`images/` and adding `image: 'images/my-dish.jpg'` to the item (otherwise an emoji tile is shown).

## Notes
- Payment uses Stripe **test mode** (card `4242 4242 4242 4242`). No real payments are possible.
- `images/hungry-character.gif` was not in the uploaded project; add it to `images/` to show the sidebar animation.
- Do not upload the Java source, `WEB-INF`, or the MySQL connector to the public repo.
