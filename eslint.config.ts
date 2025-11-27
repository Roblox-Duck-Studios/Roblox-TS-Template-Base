import isentinel from "@isentinel/eslint-config";

export default isentinel({
	gitignore: true,
	ignores: ["node_modules", "out", "dist", "include", "**/*.md", "**/*.yaml"],
	markdown: false,
	pnpm: true,
	react: true,
	type: "game",
	// yaml support is currently broken
	yaml: false,
});
