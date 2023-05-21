  async function fetchGithubEvents(organization) {
    const url = `https://api.github.com/orgs/${organization}/events`;
    const response = await fetch(url);

    if (!response.ok) {
      throw new Error(`Error fetching GitHub events: ${response.statusText}`);
    }

    return await response.json();
  }

  async function displayGithubFeed(organization) {
    try {
      const events = await fetchGithubEvents(organization);
      const listElement = document.getElementById("github-feed");
      const maxItems = 7; // Set the maximum number of activities to display

      events.slice(0, maxItems).forEach(event => {
        const listItem = document.createElement("li");
        listItem.textContent = `${event.actor.login} ${event.type} in ${event.repo.name}`;
        listElement.appendChild(listItem);
      });
    } catch (error) {
      console.error(error);
    }
  }

  displayGithubFeed("cerexas")
